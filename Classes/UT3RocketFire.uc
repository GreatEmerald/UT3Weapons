/*
 * Copyright © 2008, 2013, 2014 GreatEmerald
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     (1) Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *     (2) Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimers in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *     (3) The name of the author may not be used to
 *     endorse or promote products derived from this software without
 *     specific prior written permission.
 *
 *     (4) The use, modification and redistribution of this software must
 *     be made in compliance with the additional terms and restrictions
 *     provided by the Unreal Tournament 2004 End User License Agreement.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * This software is not supported by Atari, S.A., Epic Games, Inc. or any
 * of such parties' affiliates and subsidiaries.
 */

class UT3RocketFire extends RocketFire;

#EXEC OBJ LOAD FILE=UT3A_Weapon_RocketLauncher.uax

function StartFiring()
{
    //Instigator.ClientMessage("UT3RocketFire: StartFiring() reached");
    if (UT3RocketLauncher(Weapon) != None)
        UT3RocketLauncher(Weapon).IncrementFireModeServer();
    Super.StartFiring();
}

function PlayFiring()
{
    local bool bExactSync; //GE: When true, acts like a normal fire anim but syncs with shots.
                           //When false, acts like a fluid looping animation but can go out of sync with shots.
    local UT3RocketAttachment RLAttachment;

    bExactSync = True;

    if (bExactSync && Weapon.Mesh != None && Weapon.HasAnim(FireLoopAnim))
        Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
    else if (!bExactSync && Weapon.Mesh != None && Weapon.HasAnim(FireLoopAnim))
        Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
    else if (Weapon.Mesh != None && Weapon.HasAnim(FireAnim))
    {
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        if (UT3RocketLauncher(Weapon) == None || UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor) == None)
            return;
        RLAttachment = UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor);
        RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    }

    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);  // jdf
    FireCount++;
}

defaultproperties
{
    AmmoClass=class'UT3RocketAmmo'

    ProjectileClass=class'UT3Proj_Rocket'
    FireSound=Sound'UT3A_Weapon_RocketLauncher.UT3RocketFire.UT3RocketFireCue'
    TransientSoundVolume=0.7

    FireRate=1.050000
    FireAnim="WeaponFire"
    TweenTime=0.0
}

/*
 * Copyright © 2010, 2014 GreatEmerald
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

class UT3AVRiLAltFire extends ONSAVRiLAltFire;

#EXEC OBJ LOAD FILE=UT3A_Weapon_AVRiL.uax

var UT3AVRiLBeam Beam;
var vector EffectOffset;
var float TraceRange;

function DestroyEffects()
{
    if (Beam != None)
        Beam.Destroy();

    Super.DestroyEffects();
}

function PlayFiring()
{
    if (Weapon.AmbientSound != FireSound)
    {
        Weapon.PlayOwnedSound(sound'UT3Weapons2.AVRiL.AvrilBeamStart', SLOT_Interact, TransientSoundVolume);
        Weapon.AmbientSound = FireSound;
    }
}

simulated function bool AllowFire()
{
    if (/*bWaitingForRelease ||*/ Gun == None || !Gun.bLockedOn )//|| PlayerController(Instigator.Controller) == None)
    {
        bWaitingForRelease = true;
        return false;
    }
    else
        return true;

}

function StopFiring() //GE: Deprecated, using ModeTick instead.
{
    if (Weapon.Role == ROLE_Authority)
    {
        if (Beam != None)
        {
            Beam.Destroy();
            Weapon.AmbientSound = None;
            Weapon.PlayOwnedSound(sound'UT3Weapons2.AVRiL.AvrilBeamStop', SLOT_Interact, TransientSoundVolume);
        }
    }
    Super.StopFiring();
}

simulated function ModeTick(float deltaTime)
{
    local vector HitLocation, HitNormal, StartTrace, /*artTrace,*/ EndTrace, X, Y, Z;
    local rotator Aim;
    local Actor Other;
    //local vector LockTrace;
    //local Actor AlternateTarget;

    Super.ModeTick(DeltaTime);

    if (!bLosingLock && bIsFiring)
    {
        Weapon.GetViewAxes(X,Y,Z);

        // the to-hit trace always starts right in front of the eye
        //artTrace = GetBeamStart(X);
        StartTrace = GetBeamStart(X, true);

        Aim = AdjustAim(StartTrace, AimError);
        X = Vector(Aim);
        EndTrace = StartTrace + TraceRange * X;

        Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
        if (Other == None || Other == Instigator)
            HitLocation = EndTrace;

        if (Beam == None)
        {
            if (Weapon.Role == ROLE_Authority)
                Beam = Weapon.spawn(class'UT3AVRiLBeam',,, Instigator.Location);
            else
                foreach Weapon.DynamicActors(class'UT3AVRiLBeam', Beam)
                    break;
        }

        if (Beam != None)
            Beam.EndEffect = HitLocation;

    }
    else if (Beam != None)
    {
        Beam.Destroy();
        Weapon.AmbientSound = None;
        Weapon.PlayOwnedSound(sound'UT3Weapons2.AVRiL.AvrilBeamStop', SLOT_Interact, TransientSoundVolume);
    }


}

simulated function vector GetBeamStart(vector X, optional bool bArt)
{
    if (Instigator.Controller.Handedness == 2.0 || bArt) //GE: If the player has weapons off (what a fool!), calculate it ourselves
        return Instigator.Location + Instigator.EyePosition() + X*Instigator.CollisionRadius;
    return Weapon.GetBoneCoords('TopArmLock').Origin;
}

defaultproperties
{
    AmmoClass=class'UT3AVRiLAmmo'

    FireSound=Sound'UT3A_Weapon_AVRiL.Singles.FireAltLoop'
    TransientSoundVolume=1.0
    WarnTargetPct=0.100000
    EffectOffset=(X=-5.000000,Y=15.000000,Z=20.000000)
    TraceRange=10000.000000
}

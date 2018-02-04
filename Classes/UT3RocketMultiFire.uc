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

class UT3RocketMultiFire extends RocketMultiFire
    dependson(UT3RocketLauncher);

#EXEC OBJ LOAD FILE=UT3A_Weapon_RocketLauncher.uax

var bool bInitialAnimPlayed; //GE: Protected
var float OldLoad;
var UT3RocketLauncher.ERocketFireMode CurrentFireMode, LastFireMode; //GE: UB3R-1337 way to transfer enums
var bool bUseLastFireMode;
var(Sound) sound GrenadeFireSound;
var Sound LoadingSound;

simulated function ServerPlayLoading()
{
    UT3RocketLauncher(Weapon).PlayOwnedSound(Sound'UT3A_Weapon_RocketLauncher.LoadCue', SLOT_None,,,,,false);
}

function PlayFireEnd()
{
    Super(WeaponFire).PlayFireEnd();
}

function PlayStartHold() //GE: Rerouting to Weapon since states don't work here
{
    //log("UT3RocketMultiFire: PlayStartHold");
    // GEm: This function is client-side
    if (UT3RocketLauncher(Weapon) != None)
        UT3RocketLauncher(Weapon).GoToState('Loading');
}

function PlayFiring()
{
    local UT3RocketAttachment RLAttachment;

    if (UT3RocketLauncher(Weapon) == None || UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor) == None)
        return;
    RLAttachment = UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor);

    Weapon.GoToState('WaitForReload');

    //log("UT3RocketMultiFire: PlayFiring: Load"@Load);
    if (Load == 1.0)
        FireAnim = 'WeaponAltFireLaunch1';
    else if (Load == 2.0)
        FireAnim = 'WeaponAltFireLaunch2';
    else if (Load == 3.0)
        FireAnim = 'WeaponAltFireLaunch3';
    OldLoad = Load;
    //FireSound = Default.FireSound;
    RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    PlayRocketFire(true);
	  Weapon.OutOfAmmo();
}

function PlayRocketFire(bool CountFire, optional bool bNotExactSync, optional int Channel)
{
     //GE: When bNotExactSync is false, acts like a normal fire anim but syncs with shots.
     //When true, acts like a fluid looping animation but can go out of sync with shots.

    if (!bNotExactSync && Weapon.Mesh != None && Weapon.HasAnim(FireLoopAnim))
        Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0, Channel);
    else if (bNotExactSync && Weapon.Mesh != None && Weapon.HasAnim(FireLoopAnim))
        Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, 0.0, Channel);
    else if (Weapon.Mesh != None && Weapon.HasAnim(FireAnim))
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime, Channel);

    //log("UT3RocketMultiFire: PlayRocketFire: FireSound"@FireSound);
    if (LoadingSound != None && !CountFire)
        Weapon.PlayOwnedSound(LoadingSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    else if (CountFire) // GEm: If we're actually firing
    {
        //if (FireSound != None && ProjectileClass != Class'XWeapons.Grenade')
            Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
        /*else if (FireSound != None)
            Weapon.PlayOwnedSound(GrenadeFireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);*/
        ClientPlayForceFeedback(FireForce);  // jdf
        FireCount++;
    }
}

function Plunge(optional bool FirstRocket)
{
    local UT3RocketAttachment RLAttachment;

    //log("UT3RocketMultiFire: Plunge");
    if (UT3RocketLauncher(Weapon) == None || UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor) == None)
        return;
    RLAttachment = UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor);

    if (FirstRocket)
    {
        FireAnim = 'WeaponAltFireQueue1';
        LoadingSound = Sound'UT3A_Weapon_RocketLauncher.AltFireQueue.AltFireQueue01';
        RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        PlayRocketFire(false);
    }
    else if (Load == 1.0)
    {
        FireAnim = 'WeaponAltFireQueue2';
        LoadingSound = Sound'UT3A_Weapon_RocketLauncher.AltFireQueue.AltFireQueue02';
        RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        PlayRocketFire(false);
    }
    else if (Load == 2.0)
    {
        FireAnim = 'WeaponAltFireQueue3';
        LoadingSound = Sound'UT3A_Weapon_RocketLauncher.AltFireQueue.AltFireQueue03';
        RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        PlayRocketFire(false);
    }
}

function PlayReload()
{
    local UT3RocketAttachment RLAttachment;

    if (OldLoad == 0.0 || UT3RocketLauncher(Weapon) == None || UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor) == None)
        return;
    RLAttachment = UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor);

    if (OldLoad == 1.0)
        FireAnim = 'WeaponAltFireLaunch1End';
    else if (OldLoad == 2.0)
        FireAnim = 'WeaponAltFireLaunch2End';
    else if (OldLoad == 3.0)
        FireAnim = 'WeaponAltFireLaunch3End';
    OldLoad = 0.0;
    LoadingSound = None;
    RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    PlayRocketFire(false);
}

function ModeTick(float dt)
{
    // auto fire if loaded last rocket
    if (HoldTime >= 0.0 && Load >= Weapon.AmmoAmount(ThisModeNum) && !bNowWaiting)
    {
        //Instigator.ClientMessage("UT3RocketFire: ModeTick: Auto-fire at load"@Load);
        bIsFiring = false;
    }

    Super(ProjectileFire).ModeTick(dt);

    if (Load == 1.0 && HoldTime >= FireRate)
    {
        if (Instigator.IsLocallyControlled())
            RocketLauncher(Weapon).PlayLoad(false);
        else
            ServerPlayLoading();

        Load = Load + 1.0;
        //Instigator.ClientMessage("UT3RocketFire: ModeTick: PlayLoad, Load at"@Load);
    }
    else if (Load == 2.0 && HoldTime >= FireRate*2.0)
    {
        Load = Load + 1.0;
        //Instigator.ClientMessage("UT3RocketFire: ModeTick: Load at"@Load);
    }
}

function SwitchFireMode(UT3RocketLauncher.ERocketFireMode LoadedFireMode)
{
    if (UT3RocketLauncher(Weapon) == None || LoadedFireMode == RFM_None)
        return;
    CurrentFireMode = LoadedFireMode; //GE: Syncs the classes
    //Instigator.ClientMessage("UT3RocketMultiFire: Current mode is"@CurrentFireMode);
    //log("UT3RocketMultiFire: SwitchFireMode: LoadedFireMode"@LoadedFireMode@"bUseLastFireMode"@bUseLastFireMode@"LastFireMode"@LastFireMode);

    if ((bUseLastFireMode && LastFireMode == RFM_Spiral) || LoadedFireMode == RFM_Spiral)
    {
        UT3RocketLauncher(Weapon).SetTightSpread(true);
        ProjectileClass=default.ProjectileClass;
        bTossed=default.bTossed;
        UT3RocketLauncher(Weapon).SetFireSoundClient(default.FireSound);
        Spread = TightSpread;
        SpreadStyle = SS_Ring;
    }
    else if ((bUseLastFireMode && LastFireMode == RFM_Grenades) || LoadedFireMode == RFM_Grenades)
    {
        UT3RocketLauncher(Weapon).SetTightSpread(false);
        ProjectileClass=Class'XWeapons.Grenade';
        bTossed=True;
        UT3RocketLauncher(Weapon).SetFireSoundClient(GrenadeFireSound);
        Spread = 1400;
        SpreadStyle = SS_Random;
    }
    else //GE: Also acting as reset. Shouldn't need to be used, though.
    {
        UT3RocketLauncher(Weapon).SetTightSpread(false);
        ProjectileClass=default.ProjectileClass;
        bTossed=default.bTossed;
        UT3RocketLauncher(Weapon).SetFireSoundClient(default.FireSound);
        SpreadStyle = SS_Line;
        Spread = LooseSpread;
    }
}

function RecordMode()
{
    LastFireMode = CurrentFireMode;
    bUseLastFireMode = True;
}

//GE: On Grenades, revert the override.
function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    if (ProjectileClass == default.ProjectileClass)
        return Super.SpawnProjectile(Start, Dir);
    else
        return Super(ProjectileFire).SpawnProjectile(Start, Dir);
}

event ModeDoFire()
{
    Super(ProjectileFire).ModeDoFire();
    NextFireTime = FMax(NextFireTime, Level.TimeSeconds + FireRate);
}

function SetSpread()
{
    bUseLastFireMode = False;
    RocketLauncher(Weapon).bTightSpread = false;
}

function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator Aim;
    local Vector HitLocation, HitNormal,FireLocation;
    local Actor Other;
    local int p,q, SpawnCount, i;
    local RocketProj FiredRockets[4];
    local bool bCurl;

    SetSpread();

    if ( (SpreadStyle == SS_Line) || (SpreadStyle == SS_Random) ) //GE: Adjust this to reenable other spread modes
    {
        //Instigator.ClientMessage("UT3RocketMultiFire: SpreadStyle is"@SpreadStyle);
        Super(ProjectileFire).DoFireEffect();
        return;
    }

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X*ProjSpawnOffset.X + Z*ProjSpawnOffset.Z;
    if ( !Weapon.WeaponCentered() )
        StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, int(Load));

    for ( p=0; p<SpawnCount; p++ )
    {
        Firelocation = StartProj - 2*((Sin(p*2*PI/MaxLoad)*8 - 7)*Y - (Cos(p*2*PI/MaxLoad)*8 - 7)*Z) - X * 8 * FRand();
        FiredRockets[p] = RocketProj(SpawnProjectile(FireLocation, Aim));
    }

    if ( SpawnCount < 2 )
        return;

    FlockIndex++;
    if ( FlockIndex == 0 )
        FlockIndex = 1;

    // To get crazy flying, we tell each projectile in the flock about the others.
    for ( p = 0; p < SpawnCount; p++ )
    {
        if ( FiredRockets[p] != None )
        {
            FiredRockets[p].bCurl = bCurl;
            FiredRockets[p].FlockIndex = FlockIndex;
            i = 0;
            for ( q=0; q<SpawnCount; q++ )
                if ( (p != q) && (FiredRockets[q] != None) )
                {
                    FiredRockets[p].Flock[i] = FiredRockets[q];
                    i++;
                }
            bCurl = !bCurl;
            if ( Level.NetMode != NM_DedicatedServer )
                FiredRockets[p].SetTimer(0.1, true);
        }
    }
}


defaultproperties
{
    AmmoClass=class'UT3RocketAmmo'
    ProjectileClass=class'UT3Proj_Rocket'

    FireSound=Sound'UT3A_Weapon_RocketLauncher.Fire.FireCue'
    GrenadeFireSound=Sound'UT3A_Weapon_RocketLauncher.FireGrenade.FireGrenadeCue'
    TransientSoundVolume=1.0
    FireAnimRate=0.7

    FireRate=1.041667
    TweenTime=0.0
    bFireOnRelease=true
    MaxHoldTime=3.043333//2.9 // FireRate*2 + 0.9
    Spread=1000 // GEm: Set to LooseSpread value

    FireAnim=

}

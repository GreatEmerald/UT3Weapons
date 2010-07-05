//=============================================================================
// UT3RocketMultiFire.uc
// Hmm, not threee way... Yet...
// 2008, GreatEmerald
//=============================================================================

class UT3RocketMultiFire extends RocketMultiFire
    dependson(UT3RocketLauncher);

var bool bInitialAnimPlayed; //GE: Protected
var float OldLoad;
var UT3RocketLauncher.ERocketFireMode CurrentFireMode, LastFireMode; //GE: UB3R-1337 way to transfer enums
var bool bUseLastFireMode;
var(Sound) sound GrenadeFireSound;

simulated function ServerPlayLoading()
{
    UT3RocketLauncher(Weapon).PlayOwnedSound(Sound'UT3Weapons2.RocketLauncher.RocketLauncherLoad1', SLOT_None,,,,,false);
}

function PlayFireEnd()
{
    Super(WeaponFire).PlayFireEnd();
}

function PlayStartHold() //GE: Rerouting to Weapon since staes don't work here
{
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
    
    if (Load == 1.0)
        FireAnim = 'WeaponAltFireLaunch1';
    else if (Load == 2.0)
        FireAnim = 'WeaponAltFireLaunch2';
    else if (Load == 3.0)
        FireAnim = 'WeaponAltFireLaunch3';
    OldLoad = Load;
    FireSound = Default.FireSound;
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
    
    if (FireSound != None && !CountFire)
        Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    else if (CountFire)
    {
        if (FireSound != None && ProjectileClass != Class'XWeapons.Grenade')
            Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
        else if (FireSound != None)
            Weapon.PlayOwnedSound(GrenadeFireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false); 
        ClientPlayForceFeedback(FireForce);  // jdf
        FireCount++;
    }
}

function Plunge()
{
    local UT3RocketAttachment RLAttachment;
    
    if (UT3RocketLauncher(Weapon) == None || UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor) == None)
        return;
    RLAttachment = UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor);
    
    if (Load == 1.0)
    {
        FireAnim = 'WeaponAltFireQueue1';
        FireSound = Sound'UT3Weapons2.RocketLauncher.RocketLauncherQueue1';
        RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        PlayRocketFire(false);
    }
    else if (Load == 2.0)
    {
        FireAnim = 'WeaponAltFireQueue2';
        FireSound = Sound'UT3Weapons2.RocketLauncher.RocketLauncherLoad1';
        RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        PlayRocketFire(false);
    }
    else if (Load == 3.0)
    {
        FireAnim = 'WeaponAltFireQueue3';
        FireSound = Sound'UT3Weapons2.RocketLauncher.RocketLauncherQueue3';
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
    FireSound = None;
    RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    PlayRocketFire(false);
}

function ModeTick(float dt)
{
    // auto fire if loaded last rocket
    /*if (HoldTime >= MaxHoldTime && Load >= Weapon.AmmoAmount(ThisModeNum) && !bNowWaiting)
    {
        bIsFiring = false;
    } */

    Super(ProjectileFire).ModeTick(dt);

    if (Load == 1.0 && HoldTime >= FireRate)
    {
        if (Instigator.IsLocallyControlled())
            RocketLauncher(Weapon).PlayLoad(false);
        else
            ServerPlayLoading();
            
        Load = Load + 1.0;
    }
    else if (Load == 2.0 && HoldTime >= FireRate*2.0)
    {
        Load = Load + 1.0;
    }
}

simulated function SwitchFireMode(UT3RocketLauncher.ERocketFireMode LoadedFireMode)
{
    if (UT3RocketLauncher(Weapon) == None || LoadedFireMode == RFM_None)
        return;
    CurrentFireMode = LoadedFireMode; //GE: Syncs the classes
    //Instigator.ClientMessage("UT3RocketMultiFire: Current mode is"@CurrentFireMode);
    
    if ((bUseLastFireMode && LastFireMode == RFM_Spiral) || LoadedFireMode == RFM_Spiral)
    {
        UT3RocketLauncher(Weapon).SetTightSpread(true);
        ProjectileClass=default.ProjectileClass;
        bTossed=default.bTossed;
        FireSound=default.FireSound;
        Spread = TightSpread;
        SpreadStyle = SS_Ring;
    }
    else if ((bUseLastFireMode && LastFireMode == RFM_Grenades) || LoadedFireMode == RFM_Grenades)
    {
        UT3RocketLauncher(Weapon).SetTightSpread(false);
        ProjectileClass=Class'XWeapons.Grenade';
        bTossed=True;
        FireSound=GrenadeFireSound;
        Spread = 1400;
        SpreadStyle = SS_Random;
    }
    else //GE: Also acting as reset. Shouldn't need to be used, though.
    {
        UT3RocketLauncher(Weapon).SetTightSpread(false);
        ProjectileClass=default.ProjectileClass;
        bTossed=default.bTossed;
        FireSound=default.FireSound;
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
     GrenadeFireSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherGrenadeFire'
     MaxHoldTime=2.900000
     TransientSoundVolume=0.400000
     FireAnim=
     FireAnimRate=0.700000
     FireSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherFire'
     AmmoClass=Class'UT3Style.UT3RocketAmmo'
     ProjectileClass=Class'UT3Style.UT3RocketProj'
}

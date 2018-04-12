//==============================================================================
// UT3BioChargedFire.uc
// This goes well.
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3BioChargedFire extends BioChargedFire;

#exec obj load file=UT3A_Weapon_BioRifle.uax

var() Sound ChargedAmbientSound;

/*simulated function ModeHoldFire()
{
    if ( Weapon.AmmoAmount(ThisModeNum) > 0 )
    {
        Super(ProjectileFire).ModeHoldFire();
        GotoState('Hold');
    }
}

function float MaxRange()
{
	return 1500;
}

simulated function bool AllowFire()
{
    return (Weapon.AmmoAmount(ThisModeNum) > 0 || GoopLoad > 0);
}*/

simulated function PlayStartHold()
{
    Weapon.PlayAnim('WeaponAltCharge', 0.9, 0.1);
}


state Hold
{
    simulated function BeginState()
    {
        GoopLoad = 0;
        SetTimer(GoopUpRate, true);
        Weapon.PlayOwnedSound(HoldSound, SLOT_Interact, 1.0);
        Weapon.ClientPlayForceFeedback( "BioRiflePowerUp" );  // jdf
        Timer();
    }

    simulated function Timer()
    {
        if ( Weapon.AmmoAmount(ThisModeNum) > 0 )
            GoopLoad++;
        Weapon.ConsumeAmmo(ThisModeNum, 1);
        if (GoopLoad == MaxGoopLoad || Weapon.AmmoAmount(ThisModeNum) == 0)
        {
            SetTimer(0.0, false);
            Instigator.AmbientSound = ChargedAmbientSound;
            Instigator.SoundRadius = 255;
            Instigator.SoundVolume = 255;
            Weapon.LoopAnim(FireLoopAnim);
        }
    }

    simulated function EndState()
    {
        if ( (Instigator != None) && (Instigator.AmbientSound == ChargedAmbientSound) )
            Instigator.AmbientSound = None;
        Instigator.SoundRadius = Instigator.Default.SoundRadius;
        Instigator.SoundVolume = Instigator.Default.SoundVolume;

        StopForceFeedback( "BioRiflePowerUp" );  // jdf
    }
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local BioGlob Glob;

    /* GEm: The below is only executed on the server! We need this
            replicated on the client so they don't go out of sync! */
    GotoState('');

    if (GoopLoad == 0) return None;

    Glob = Weapon.Spawn(class'UT3BioGlobCharged',,, Start, Dir);
    if ( Glob != None )
    {
        Glob.Damage *= DamageAtten;
        Glob.SetGoopLevel(GoopLoad);
        Glob.AdjustSpeed();
    }
    GoopLoad = 0;
    if ( Weapon.AmmoAmount(ThisModeNum) <= 0 )
        Weapon.OutOfAmmo();
    return Glob;
}

function PlayFiring()
{
    // GEm: Sync the state for the network client
    GotoState('');
    Super.PlayFiring();
}

defaultproperties
{
    AmmoClass=class'UT3BioAmmo'
    ProjectileClass=class'UT3BioGlobCharged'
    ChargedAmbientSound=Sound'UT3A_Weapon_BioRifle.UT3BioSingles.UT3BioFireAltChamberIdleLoopCueAll'
    HoldSound=Sound'UT3A_Weapon_BioRifle.UT3BioFireAltChamberRotate.UT3BioFireAltChamberRotateCue'
    FireSound=Sound'UT3A_Weapon_BioRifle.UT3BioFireAltLarge.UT3BioFireAltLargeCue'
    TransientSoundVolume=1.5
    FireRate=0.35
    //TransientSoundVolume=0.6
    
      GoopUpRate=0.350000
      FireAnim="WeaponAltFire"
      FireLoopAnim="weaponaltidle"
      FireAnimRate=2.000000
}


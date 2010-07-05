//==============================================================================
// UT3BioChargedFire.uc
// This goes well.
// 2008, GreatEmerald
//==============================================================================

class UT3BioChargedFire extends BioChargedFire;

var() Sound ChargedAmbientSound;


function ModeHoldFire()
{
    if ( Weapon.AmmoAmount(ThisModeNum) > 0 )
    {
        Super.ModeHoldFire();
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
}

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
        Weapon.PlayOwnedSound(HoldSound,SLOT_Interact,1.0);
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
            Instigator.SoundRadius = 50;
            Instigator.SoundVolume = 50;
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

defaultproperties
{
     ChargedAmbientSound=Sound'UT3Weapons2.BioRifle.BioRifleLoaded'
     GoopUpRate=0.350000
     HoldSound=Sound'UT3Weapons2.BioRifle.BioRifleLoad'
     FireAnim="WeaponAltFire"
     FireLoopAnim="WeaponAltIdle"
     FireAnimRate=2.000000
     FireSound=Sound'UT3Weapons2.BioRifle.BioRifleAltFire'
     FireRate=0.350000
     AmmoClass=Class'UT3Style.UT3BioAmmo'
     ProjectileClass=Class'UT3Style.UT3BioGlobCharged'
}

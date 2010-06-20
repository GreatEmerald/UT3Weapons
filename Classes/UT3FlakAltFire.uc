//==============================================================================
// UT3FlakAltFire.uc
// sHell.
// 2008, GreatEmerald
//==============================================================================

class UT3FlakAltFire extends FlakAltFire;

defaultproperties
{
    AmmoClass=class'UT3FlakAmmo'

    ProjectileClass=class'UT3FlakShell'
    FireSound=Sound'UT3Weapons2.FlakCannon.FlakCannon_FireAltCue'
    TransientSoundVolume=1.0

    FireRate=1.0
    FireAnim="WeaponFire"
}


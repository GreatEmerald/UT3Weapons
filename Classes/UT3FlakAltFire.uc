//==============================================================================
// UT3FlakAltFire.uc
// sHell.
// 2008, GreatEmerald
//==============================================================================

class UT3FlakAltFire extends FlakAltFire;

defaultproperties
{
     TransientSoundVolume=1.000000
     FireAnim="WeaponFire"
     FireSound=SoundGroup'UT3Weapons2.FlakCannon.FlakCannon_FireAltCue'
     FireRate=1.000000
     AmmoClass=Class'UT3Style.UT3FlakAmmo'
     ProjectileClass=Class'UT3Style.UT3FlakShell'
}

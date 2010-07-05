//==============================================================================
// UT3FlakFire.uc
// Shrapnel...
// 2008, GreatEmerald
//==============================================================================

class UT3FlakFire extends FlakFire;

defaultproperties
{
     TransientSoundVolume=1.000000
     FireAnim="WeaponFire"
     FireSound=SoundGroup'UT3Weapons2.FlakCannon.FlakCannon_FireCue'
     FireRate=1.100000
     AmmoClass=Class'UT3Style.UT3FlakAmmo'
     ProjectileClass=Class'UT3Style.UT3FlakChunk'
     Spread=1024.000000
}

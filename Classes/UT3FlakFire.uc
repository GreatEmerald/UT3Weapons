//==============================================================================
// UT3FlakFire.uc
// Shrapnel...
// 2008, GreatEmerald
//==============================================================================

class UT3FlakFire extends FlakFire;

defaultproperties
{
    AmmoClass=class'UT3FlakAmmo'

    ProjectileClass=class'UT3FlakChunk'

    Spread=1024

    FireSound=Sound'UT3Weapons2.FlakCannon.FlakCannon_FireCue'
    TransientSoundVolume=1.0

    FireRate=1.1
    
     FireAnim="WeaponFire"
}

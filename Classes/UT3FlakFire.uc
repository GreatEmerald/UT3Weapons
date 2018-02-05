//==============================================================================
// UT3FlakFire.uc
// Shrapnel...
// 2008, GreatEmerald
//==============================================================================

class UT3FlakFire extends FlakFire;

#exec obj load file=UT3A_Weapon_FlakCannon.uax

defaultproperties
{
    AmmoClass=class'UT3FlakAmmo'

    ProjectileClass=class'UT3FlakChunk'

    Spread=1024

    FireSound=SoundGroup'UT3A_Weapon_FlakCannon.Fire.FireCue'
    TransientSoundVolume=1.0

    FireRate=1.1
    
     FireAnim="WeaponFire"
}

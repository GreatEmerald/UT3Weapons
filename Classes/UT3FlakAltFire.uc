//==============================================================================
// UT3FlakAltFire.uc
// sHell.
// 2008, GreatEmerald
//==============================================================================

class UT3FlakAltFire extends FlakAltFire;

#exec obj load file=UT3A_Weapon_FlakCannon.uax

defaultproperties
{
    AmmoClass=class'UT3FlakAmmo'

    ProjectileClass=class'UT3FlakShell'
    FireSound=SoundGroup'UT3A_Weapon_FlakCannon.UT3FlakFireAlt.UT3FlakFireAltCue'
    TransientSoundVolume=1.0

    FireRate=1.0
    FireAnim="WeaponFire"
}


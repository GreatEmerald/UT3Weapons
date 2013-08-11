//==============================================================================
// UT3BioRiflePickup.uc
// It had a nice sound all along, but it was unused!
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3BioRiflePickup extends BioRiflePickup;

defaultproperties
{
    InventoryType=class'UT3BioRifle'

    PickupMessage="Bio Rifle"
    PickupSound=Sound'UT3PickupSounds.Generic.BioRiflePickup'
    TransientSoundVolume=1.15
    StaticMesh=StaticMesh'UT3WPStatics.UT3BioPickup'
    Skins(0)=Shader'UT3WeaponSkins.BioRifle.BioRifle_Skin'
    AmbientGlow=77
}


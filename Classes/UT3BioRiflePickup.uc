//==============================================================================
// UT3BioRiflePickup.uc
// It had a nice sound all along, but it was unused!
// 2008, GreatEmerald
//==============================================================================

class UT3BioRiflePickup extends BioRiflePickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3BioRifle'
     PickupMessage="Bio Rifle"
     PickupSound=Sound'UT3PickupSounds.Generic.BioRiflePickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3BioPickup'
     Skins(0)=Shader'UT3WeaponSkins.BioRifle.BioRifle_Skin'
     TransientSoundVolume=1.150000
}

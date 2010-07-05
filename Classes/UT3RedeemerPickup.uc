//=============================================================================
// UT3RedeemerPickup.uc
// Woah it's big.
// 2008, GreatEmerald
//=============================================================================

class UT3RedeemerPickup extends RedeemerPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3Redeemer'
     PickupMessage="Redeemer"
     PickupSound=Sound'UT3PickupSounds.Generic.RedeemerPickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3RedeemerPickup'
     Skins(0)=Shader'UT3WeaponSkins.Redeemer.RedeemerSkin'
     Skins(1)=Shader'UT3WeaponSkins.Redeemer.RedeemerLauncher'
     TransientSoundVolume=0.730000
}

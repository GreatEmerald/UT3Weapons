//=============================================================================
// UT3RedeemerPickup.uc
// Woah it's big.
// 2008, 2013 GreatEmerald
//=============================================================================

class UT3RedeemerPickup extends RedeemerPickup;

defaultproperties
{
    InventoryType=class'UT3Redeemer'

    PickupMessage="Redeemer"
    MessageClass=class'UT3PickupMessage'
    PickupSound=Sound'UT3PickupSounds.Generic.RedeemerPickup'
    TransientSoundVolume=0.73
    StaticMesh=StaticMesh'UT3WPStatics.UT3RedeemerPickup'
    Skins(0)=Shader'UT3WeaponSkins.Redeemer.RedeemerSkin'
    Skins(1)=Shader'UT3WeaponSkins.Redeemer.RedeemerLauncher'
    AmbientGlow=77
}

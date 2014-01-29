//==============================================================================
// UT3BioRiflePickup.uc
// It had a nice sound all along, but it was unused!
// 2008, 2013, 2014 GreatEmerald
//==============================================================================

class UT3BioRiflePickup extends UT3WeaponPickup;

defaultproperties
{
    InventoryType=class'UT3BioRifle'
    PickupMessage="Bio Rifle"
    PickupSound=Sound'UT3PickupSounds.Generic.BioRiflePickup'
    TransientSoundVolume=1.15
    StaticMesh=StaticMesh'UT3WPStatics.UT3BioPickup'
    DrawScale=0.6
    Skins(0)=Shader'UT3WeaponSkins.BioRifle.BioRifle_Skin'
    StandUp=(X=0.25)
    MaxDesireability=+0.75
    PickupForce="FlakCannonPickup"
}


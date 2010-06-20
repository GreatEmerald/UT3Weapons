//==============================================================================
// UT3BioAmmoPickup.uc
// Pack...
// 2008, GreatEmerald
//==============================================================================

class UT3BioAmmoPickup extends BioAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3BioAmmo'
    PickupMessage="Bio Rifle Ammo"
    PickupSound=Sound'UT3PickupSounds.BioSludgePickup'
    TransientSoundVolume=1.15
}

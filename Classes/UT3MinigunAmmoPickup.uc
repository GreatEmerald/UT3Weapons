//==============================================================================
// UT3MinigunAmmoPickup.uc
// A can of crystals?
// 2008, GreatEmerald
//==============================================================================

class UT3MinigunAmmoPickup extends MinigunAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3MinigunAmmo'

    PickupMessage="Stinger Shards"
    PickupSound=Sound'UT3PickupSounds.MiniAmmoPickup'
}

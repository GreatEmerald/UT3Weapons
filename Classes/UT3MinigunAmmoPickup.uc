//==============================================================================
// UT3MinigunAmmoPickup.uc
// A can of crystals?
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3MinigunAmmoPickup extends MinigunAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3MinigunAmmo'

    PickupMessage="Stinger Shards"
    PickupSound=Sound'UT3PickupSounds.MiniAmmoPickup'
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.StingerAmmo'
    DrawScale=1.7
    PrePivot=(Z=2.5)
}

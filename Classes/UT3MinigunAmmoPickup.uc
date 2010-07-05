//==============================================================================
// UT3MinigunAmmoPickup.uc
// A can of crystals?
// 2008, GreatEmerald
//==============================================================================

class UT3MinigunAmmoPickup extends MinigunAmmoPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3MinigunAmmo'
     PickupMessage="Stinger Shards"
     PickupSound=Sound'UT3PickupSounds.Generic.MiniAmmoPickup'
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.StingerAmmo'
     DrawScale=1.700000
     PrePivot=(Z=2.500000)
}

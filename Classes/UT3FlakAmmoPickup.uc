//==============================================================================
// UT3FlakAmmoPickup.uc
// Short file too.
// 2008, GreatEmerald
//==============================================================================

class UT3FlakAmmoPickup extends FlakAmmoPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3FlakAmmo'
     PickupMessage="Flak Shells"
     PickupSound=Sound'UT3PickupSounds.Generic.FlakAmmoPickup'
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.FlakCannonAmmo'
     DrawScale=1.600000
     PrePivot=(Z=2.000000)
}

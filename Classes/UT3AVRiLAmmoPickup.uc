//=============================================================================
// UT3AVRiLAmmoPickup.uc
// Yet I still need the class for referencing AVRiLAmmo.
// 2008, GreatEmerald
//=============================================================================

class UT3AVRiLAmmoPickup extends ONSAVRiLAmmoPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3AVRiLAmmo'
     PickupMessage="Longbow AVRiL Ammo"
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.AVRILammo'
     DrawScale=1.600000
     PrePivot=(Z=5.000000)
}

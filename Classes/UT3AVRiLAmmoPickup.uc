//=============================================================================
// UT3AVRiLAmmoPickup.uc
// Yet I still need the class for referencing AVRiLAmmo.
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//=============================================================================

class UT3AVRiLAmmoPickup extends ONSAVRiLAmmoPickup;

DefaultProperties
{
    InventoryType=class'UT3AVRiLAmmo' //what item to create in inventory (Epic comment)
    PickupMessage="Longbow AVRiL Ammo"
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.AVRILammo'
    DrawScale=1.8
    PrePivot=(Z=4.0)
    AmbientGlow=77
}

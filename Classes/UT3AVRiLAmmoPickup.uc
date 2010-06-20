//=============================================================================
// UT3AVRiLAmmoPickup.uc
// Yet I still need the class for referencing AVRiLAmmo.
// 2008, GreatEmerald
//=============================================================================

class UT3AVRiLAmmoPickup extends ONSAVRiLAmmoPickup;

DefaultProperties
{
    InventoryType=class'UT3AVRiLAmmo' //what item to create in inventory (Epic comment)
    PickupMessage="Longbow AVRiL Ammo"
}

//=============================================================================
// UT3InstagibRiflePickup.uc
// This isn't your usual weapon.
// 2008, 2013, 2014 GreatEmerald
//=============================================================================

class UT3InstagibRiflePickup extends UT3WeaponPickup;

defaultproperties
{
    InventoryType=class'UT3InstagibRifle'

    PickupMessage="Instagib ShockRifle"
    PickupSound=Sound'PickupSounds.ShockRiflePickup'
    PickupForce="ShockRiflePickup"  // jdf

    MaxDesireability=+0.65

    StaticMesh=staticmesh'NewWeaponPickups.ShockPickupSM'
    DrawScale=0.5
}

//=============================================================================
// UT3InstagibRiflePickup.uc
// This isn't your usual weapon.
// 2008, 2013 GreatEmerald
//=============================================================================

class UT3InstagibRiflePickup extends SuperShockRiflePickup;

defaultproperties
{
    InventoryType=class'UT3InstagibRifle'

    PickupMessage="Instagib ShockRifle"
    MessageClass=class'UT3PickupMessage'
    PickupSound=Sound'PickupSounds.ShockRiflePickup'
    PickupForce="ShockRiflePickup"  // jdf

    MaxDesireability=+0.65

    StaticMesh=staticmesh'NewWeaponPickups.ShockPickupSM'
    DrawType=DT_StaticMesh
    DrawScale=0.5
    AmbientGlow=77
}

//=============================================================================
// UT3ArmorPickup_ThighPads.uc
// The actual pickup for thigh pads
// Copyright © 2014 GreatEmerald
//=============================================================================

class UT3ArmorPickup_ThighPads extends UT3ArmorPickup;

defaultproperties
{
    InventoryType = class'UT3ArmorThighPads'
    MaxDesireability = 1.0
    StaticMesh = StaticMesh'UT3PICKUPS_Mesh.ThighPads.S_Pickups_ThighPads'
    DrawScale = 3.0
    PrePivot = (Z=10)
    PickupSound = Sound'UT3A_Pickups.Armor.A_Pickups_Armor_Thighpads01'
    PickupMessage = "Thighpads"
    PickupForce = "ShieldPack"
    BasicTexture = Material'UT3Pickups.ThighPads.T_Pickups_ThighPads_D'
}

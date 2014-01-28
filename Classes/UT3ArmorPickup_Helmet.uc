//=============================================================================
// UT3ArmorPickup_Helmet.uc
// The actual pickup for the helmet
// Copyright © 2014 GreatEmerald
//=============================================================================

class UT3ArmorPickup_Helmet extends UT3ArmorPickup;

defaultproperties
{
    InventoryType = class'UT3ArmorHelmet'
    MaxDesireability = 1.0
    StaticMesh = StaticMesh'UT3PICKUPS_Mesh.Armor_Helmet.S_UN_Pickups_Helmet'
    DrawScale = 2.0
    PickupSound = Sound'UT3A_Pickups.Armor.A_Pickups_Armor_Helmet01'
    PickupMessage = "Armored Helmet"
    PickupForce = "ShieldPack"
    BasicTexture = Material'UT3Pickups.Armor_Helmet.T_Pickups_Helmet_D'
}

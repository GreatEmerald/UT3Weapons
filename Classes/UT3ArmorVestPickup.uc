/******************************************************************************
UT3ArmorVestPickup

Creation date: 2008-07-19 18:45
Last change: $Id$
Copyright (c) 2008, 2010, 2013 Wormbo, 100GPing100, GreatEmerald
******************************************************************************/

class UT3ArmorVestPickup extends UT3ArmorPickup;


//=============================================================================
// Imports
//=============================================================================


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    InventoryType = class'UT3ArmorVest'
    PickupSound   = Sound'UT3A_Pickups.Armor.A_Pickups_Armor_Chest01'
    PickupMessage = "Armor Vest"
    PickupForce   = "ShieldPack"
    StaticMesh    = StaticMesh'UT3Pickups-SM.Powerups.Vest'
    Physics       = PHYS_Rotating
    RotationRate  = (Yaw=24000)
    DrawScale     = 1.000000
    Basictexture  = Material'UT3Pickups.Vest.Armor_D'
}

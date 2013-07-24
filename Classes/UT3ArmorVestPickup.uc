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

#exec audio import file=Sounds\PickupArmorChest.wav group=Pickups


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	InventoryType = class'UT3ArmorVest'
	PickupSound   = Sound'PickupArmorChest'
	PickupMessage = "Armor Vest"
	PickupForce   = "ShieldPack"
	StaticMesh    = StaticMesh'UT3Pickups-SM.Powerups.Vest'
	Physics       = PHYS_Rotating
	RotationRate  = (Yaw=24000)
	Skins(0)      = Shader'UT3Pickups.Vest.VestSkin'
	DrawScale     = 0.800000
}

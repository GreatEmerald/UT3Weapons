/******************************************************************************
UT3ArmorVestPickup

Creation date: 2008-07-19 18:45
Last change: $Id$
Copyright (c) 2008, Wormbo
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
	StaticMesh    = StaticMesh'E_Pickups.RegShield'
    Physics       = PHYS_Rotating
	RotationRate  = (Yaw=24000)
	Skins         = (FinalBlend'PickupSkins.Shaders.ShieldFinal',FinalBlend'PickupSkins.Shaders.FinalHealthGlass')
}

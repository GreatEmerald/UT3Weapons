/******************************************************************************
UT3ArmorShieldbeltPickup

Creation date: 2008-07-19 18:45
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3ArmorShieldbeltPickup extends UT3ArmorPickup;


//=============================================================================
// Imports
//=============================================================================

#exec audio import file=Sounds\PickupArmorShieldbelt.wav group=Pickups


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	RespawnTime   = 60.0
	MaxDesireability = 1.5
	InventoryType = class'UT3ArmorShieldbelt'
	PickupSound   = Sound'PickupArmorShieldbelt'
	PickupMessage = "Shield Belt"
	PickupForce   = "LargeShieldPickup"
	StaticMesh    = StaticMesh'E_Pickups.SuperShield'
    Physics       = PHYS_Rotating
	RotationRate  = (Yaw=24000)
    DrawScale     = 0.6
	Skins         = (FinalBlend'PickupSkins.Shaders.ShieldFinal',FinalBlend'PickupSkins.Shaders.ShieldPanFinal',FinalBlend'PickupSkins.Shaders.FinalHealthGlass')
}

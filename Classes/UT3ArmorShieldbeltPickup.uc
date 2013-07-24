/******************************************************************************
UT3ArmorShieldbeltPickup

Creation date: 2008-07-19 18:45
Last change: $Id$
Copyright (c) 2008, 2010, 2013 Wormbo, 100GPing100, GreatEmerald
******************************************************************************/

class UT3ArmorShieldbeltPickup extends UT3ArmorPickup;


//=============================================================================
// Imports
//=============================================================================

#exec audio import file=Sounds\include\PickupArmorShieldbelt.wav group=Pickups


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
	StaticMesh    = StaticMesh'UT3Pickups-SM.Powerups.ShieldBelt'
	Physics       = PHYS_Rotating
	RotationRate  = (Yaw=24000)
	DrawScale     = 1.6
	PrePivot      = (Z=10.000000)
	Skins(0)      = Shader'UT3Pickups.ShieldBelt.ShieldBeltSkin'
}

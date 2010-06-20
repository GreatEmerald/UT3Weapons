/******************************************************************************
UT3UDamagePickup

Creation date: 2008-07-19 18:14
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3UDamagePickup extends UT3TimedPickup;


//=============================================================================
// Imports
//=============================================================================

#exec audio import group=UDamage file=Sounds\UDamage\UDamageSpawn.wav
#exec audio import group=UDamage file=Sounds\UDamage\UDamageGroundLoop.wav
#exec audio import group=UDamage file=Sounds\UDamage\UDamagePickup.wav


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	InventoryType       = class'UT3UDamage'
	TimeRemaining       = 30.0
	RespawnSound        = Sound'UDamageSpawn'
	SpawnedAmbientSound = Sound'UDamageGroundLoop'
	PickupSound         = Sound'UDamagePickup'
	PickupMessage       = "DAMAGE AMP!"
	
	PickupForce  = "UDamagePickup"
	Physics      = PHYS_Rotating
	RotationRate = (Yaw=24000)
	
	DrawScale  = 0.9
	StaticMesh = StaticMesh'E_Pickups.Udamage'
	Skins      = (FinalBlend'PickupSkins.Shaders.FinalDamShader',FinalBlend'PickupSkins.Shaders.FinalHealthGlass')
}

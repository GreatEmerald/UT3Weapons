/******************************************************************************
UT3UDamagePickup

Creation date: 2008-07-19 18:14
Last change: $Id$
Copyright (c) 2008, 2010, 2013 Wormbo, 100GPing100, GreatEmerald
******************************************************************************/

class UT3UDamagePickup extends UT3TimedPickup;


//=============================================================================
// Imports
//=============================================================================

#exec audio import group=UDamage file=Sounds\include\UDamage\UDamageSpawn.wav
#exec audio import group=UDamage file=Sounds\include\UDamage\UDamageGroundLoop.wav
#exec audio import group=UDamage file=Sounds\include\UDamage\UDamagePickup.wav
#exec OBJ LOAD FILE=UT3PickupsOld.utx
#exec OBJ LOAD FILE=UT3Pickups-SM.usx


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

    DrawScale  = 0.6
    StaticMesh = StaticMesh'UT3Pickups-SM.Powerups.Udamage'
}

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

//#exec OBJ LOAD FILE=UT3PickupsOld.utx
#exec OBJ LOAD FILE=UT3Pickups-SM.usx


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    InventoryType       = class'UT3UDamage'
    TimeRemaining       = 30.0
    RespawnSound        = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_Spawn'
    SpawnedAmbientSound = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_GroundLoop'
    PickupSound         = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_Pickup'
    PickupMessage       = "DAMAGE AMP!"
    MessageClass        = class'UT3PickupMessage'

    PickupForce  = "UDamagePickup"
    Physics      = PHYS_Rotating
    RotationRate = (Yaw=24000)

    DrawScale  = 0.6
    StaticMesh = StaticMesh'UT3Pickups-SM.Powerups.Udamage'
    AmbientGlow = 77
}

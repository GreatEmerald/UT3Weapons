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
#exec OBJ LOAD FILE=UT3Pickups.utx
#exec OBJ LOAD FILE=UT3Pickups-SM.usx


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     RespawnSound=Sound'UT3Style.Udamage.UDamageSpawn'
     SpawnedAmbientSound=Sound'UT3Style.Udamage.UDamageGroundLoop'
     InventoryType=Class'UT3Style.UT3UDamage'
     PickupMessage="DAMAGE AMP!"
     PickupSound=Sound'UT3Style.Udamage.UDamagePickup'
     PickupForce="UDamagePickup"
     StaticMesh=StaticMesh'UT3Pickups-SM.Powerups.Udamage'
     Physics=PHYS_Rotating
     Skins(0)=Shader'UT3Pickups.Udamage.UdamageSkin'
     Skins(1)=Shader'UT3Pickups.Udamage.UDamageSkin2'
     RotationRate=(Yaw=24000)
}

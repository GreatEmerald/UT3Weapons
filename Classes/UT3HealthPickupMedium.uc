/******************************************************************************
UT3HealthPickupMedium

Creation date: 2008-07-19 15:34
Last change: $Id$
Copyright (c) 2008, 2010, 2013 Wormbo, 100GPing100, GreatEmerald
******************************************************************************/

class UT3HealthPickupMedium extends UT3HealthPickup;


//=============================================================================
// Imports
//=============================================================================

// GEm: Will need to fix this later
/*


simulated function PostBeginPlay()
{
	local UT3MaterialManager MaterialManager;

	Super.PostBeginPlay();

	if (Level.NetMode != NM_DedicatedServer) {
		MaterialManager = class'UT3MaterialManager'.static.GetMaterialManager(Level);
		RespawnBuildGlow = MaterialManager.GetSpawnEffectPanner(1.6 / GetSoundDuration(RespawnSound));
		Skins[0] = MaterialManager.GetSpawnEffectHealth(RespawnBuildGlow);
		Skins[2] = MaterialManager.GetSpawnEffectGlass(RespawnBuildGlow);

		PostNetReceive();
	}
}


simulated function Destroyed()
{
	local UT3MaterialManager MaterialManager;

	if (Level.NetMode != NM_DedicatedServer) {
		MaterialManager = class'UT3MaterialManager'.static.GetMaterialManager(Level);
		MaterialManager.ReleaseSpawnEffect(Skins[0]);
		MaterialManager.ReleaseSpawnEffect(Skins[2]);
		MaterialManager.ReleaseSpawnEffect(RespawnBuildGlow);
	}
	Super.Destroyed();
}*/


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    PickupSound = Sound'UT3A_Pickups.Health.A_Pickups_Health_Medium01'
    StaticMesh = StaticMesh'UT3Pickups-SM.Powerups.HealthMedium'
    DrawScale = 1.0
    RotationRate = (Yaw=16384)
    PickupMessage = "Health Pack +"
    bFloatingPickup = true
    bRandomStart = true
    BobSpeed = 1.0
    BobOffset = 5.0
    PickupForce = "HealthPack"
    CollisionRadius = 32.0
    HealingAmount = 25
    CullDistance = +6500.0
}

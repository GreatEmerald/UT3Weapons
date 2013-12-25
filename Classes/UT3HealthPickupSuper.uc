/******************************************************************************
UT3HealthPickupSuper

Creation date: 2008-07-18 18:05
Last change: $Id$
Copyright (c) 2008, 2013 Wormbo, Greatemerald
******************************************************************************/

class UT3HealthPickupSuper extends UT3HealthPickup;


//=============================================================================
// Imports
//=============================================================================


/*simulated function PostBeginPlay()
{
	local UT3MaterialManager MaterialManager;

	Super.PostBeginPlay();

	if (Level.NetMode != NM_DedicatedServer) {
		MaterialManager = class'UT3MaterialManager'.static.GetMaterialManager(Level);
		RespawnBuildGlow = MaterialManager.GetSpawnEffectPanner(1.6 / GetSoundDuration(RespawnSound));
		Skins[0] = MaterialManager.GetSpawnEffectTexture(RespawnBuildGlow, Texture'PickupSkins.Health.SuperkegSkin');
		Skins[1] = MaterialManager.GetSpawnEffectHealth(RespawnBuildGlow);

		PostNetReceive();
	}
}


simulated function Destroyed()
{
	local UT3MaterialManager MaterialManager;

	if (Level.NetMode != NM_DedicatedServer) {
		MaterialManager = class'UT3MaterialManager'.static.GetMaterialManager(Level);
		MaterialManager.ReleaseSpawnEffect(Skins[0]);
		MaterialManager.ReleaseSpawnEffect(Skins[1]);
		MaterialManager.ReleaseSpawnEffect(RespawnBuildGlow);
	}
	Super.Destroyed();
}*/


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    PickupSound = Sound'UT3PickupSounds.Generic.SuperHealthPickup'
    StaticMesh = StaticMesh'UT3PICKUPS_Mesh.Health_Large.S_Pickups_Health_Large_Keg'
    DrawScale = 1.0
    RotationRate = (Yaw=16384)
    PickupMessage = "Big Keg O' Health +"
    MaxDesireability = 2.0
    RespawnTime = 60.0
    bSuperHeal = true
    PickupForce = "LargeHealthPickup"
    CollisionRadius = 42.0
    HealingAmount = 100
    bPredictRespawns = true
    BasicTexture = Material'UT3Pickups.Health_Large.T_Pickups_Health_Large_Keg_D'
}

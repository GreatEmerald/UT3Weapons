/******************************************************************************
UT3HealthPickupSmall

Creation date: 2008-07-20 19:17
Latest change: $Id$
Copyright (c) 2008, 2013 Wormbo, GreatEmerald
******************************************************************************/

class UT3HealthPickupSmall extends UT3HealthPickup;


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
		Skins[0] = MaterialManager.GetSpawnEffectTexture(RespawnBuildGlow, Texture'XGameTextures.SuperPickups.MHPickup');
		Skins[1] = MaterialManager.GetSpawnEffectBubbles(RespawnBuildGlow);

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
    PickupSound = Sound'UT3PickupSounds.Generic.HealthVialPickup'
    StaticMesh = StaticMesh'UT3PICKUPS_Mesh.Health_Small.S_Pickups_Health_Small'
    DrawScale = 1.0
    PickupMessage = "Health Vial +"
    RotationRate = (Yaw=32000)
    bFloatingPickup = true
    bRandomStart = true
    BobOffset = 5.0
    BobSpeed = 4.0
    MaxDesireability = 0.3
    bSuperHeal = true
    PickupForce = "HealthPack"
    CollisionRadius = 24.0
    HealingAmount = 5
    CullDistance = +4500.0
}

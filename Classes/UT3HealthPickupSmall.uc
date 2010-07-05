/******************************************************************************
UT3HealthPickupSmall

Creation date: 2008-07-20 19:17
Latest change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3HealthPickupSmall extends MiniHealthPack;


//=============================================================================
// Imports
//=============================================================================

#exec audio import file=Sounds\PickupHealthSmall.wav group=Pickups


//=============================================================================
// Properties
//=============================================================================

var() Sound RespawnSound;


//=============================================================================
// Variables
//=============================================================================

var TexPannerTriggered RespawnBuildGlow;
var bool bWasHidden;


simulated function PostBeginPlay()
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
}


function RespawnEffect()
{
	PlaySound(RespawnSound);
}


simulated function PostNetReceive()
{
	if (!bHidden && bWasHidden) {
		RespawnBuildGlow.Trigger(Self, None);
	}
	bWasHidden = bHidden;
}


state Sleeping
{
	function BeginState()
	{
		Super.BeginState();
		if (Level.NetMode != NM_DedicatedServer)
			PostNetReceive();
	}
	
	function EndState()
	{
		Super.EndState();
		if (Level.NetMode != NM_DedicatedServer)
			PostNetReceive();
	}
	
DelayedSpawn:
Begin:
	Sleep(GetReSpawnTime() - RespawnEffectTime);
Respawn:
	RespawnEffect();
	Sleep(RespawnEffectTime);
    if (PickUpBase != None)
		PickUpBase.TurnOn();
    GotoState('Pickup');
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     RespawnSound=Sound'UT3Style.Pickups.RespawnHealth'
     bWasHidden=True
     RespawnEffectTime=0.000000
     PickupSound=Sound'UT3Style.Pickups.PickupHealthSmall'
     TransientSoundVolume=0.750000
     TransientSoundRadius=1000.000000
     bNetNotify=True
}

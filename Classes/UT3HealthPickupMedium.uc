/******************************************************************************
UT3HealthPickupMedium

Creation date: 2008-07-19 15:34
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3HealthPickupMedium extends HealthPack;


//=============================================================================
// Imports
//=============================================================================

#exec audio import file=Sounds\RespawnHealth.wav group=Pickups
#exec audio import file=Sounds\PickupHealthMedium.wav group=Pickups


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
     PickupSound=Sound'UT3Style.Pickups.PickupHealthMedium'
     StaticMesh=StaticMesh'UT3Pickups-SM.Powerups.HealthMedium'
     DrawScale=1.600000
     TransientSoundVolume=0.750000
     TransientSoundRadius=1000.000000
     bNetNotify=True
}

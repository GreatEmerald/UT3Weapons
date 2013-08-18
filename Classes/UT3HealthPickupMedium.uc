/******************************************************************************
UT3HealthPickupMedium

Creation date: 2008-07-19 15:34
Last change: $Id$
Copyright (c) 2008, 2010, 2013 Wormbo, 100GPing100, GreatEmerald
******************************************************************************/

class UT3HealthPickupMedium extends HealthPack;


//=============================================================================
// Imports
//=============================================================================

#exec audio import file=Sounds\include\RespawnHealth.wav group=Pickups
#exec audio import file=Sounds\include\PickupHealthMedium.wav group=Pickups


//=============================================================================
// Properties
//=============================================================================

var() Sound RespawnSound;


//=============================================================================
// Variables
//=============================================================================

// GEm: Will need to fix this later
/*var TexPannerTriggered RespawnBuildGlow;
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
}*/


function RespawnEffect()
{
	PlaySound(RespawnSound);
}


/*simulated function PostNetReceive()
{
	if (!bHidden && bWasHidden) {
		RespawnBuildGlow.Trigger(Self, None);
	}
	bWasHidden = bHidden;
}*/


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
    //bWasHidden = True
    bNetNotify = True
    RespawnEffectTime = 0.0
    PickupSound = Sound'PickupHealthMedium'
    RespawnSound = Sound'RespawnHealth'
    TransientSoundVolume = 0.75
    TransientSoundRadius = 1000.0
    StaticMesh=StaticMesh'UT3Pickups-SM.Powerups.HealthMedium'
    DrawScale=1.600000
    AmbientGlow=77
    ScaleGlow=1.0
    RotationRate = (Yaw=16384)
    PickupMessage="Health Pack +"
}

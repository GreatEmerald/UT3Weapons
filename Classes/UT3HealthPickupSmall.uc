/******************************************************************************
UT3HealthPickupSmall

Creation date: 2008-07-20 19:17
Latest change: $Id$
Copyright (c) 2008, 2013 Wormbo, GreatEmerald
******************************************************************************/

class UT3HealthPickupSmall extends MiniHealthPack;


//=============================================================================
// Imports
//=============================================================================

#exec audio import file=Sounds\include\PickupHealthSmall.wav group=Pickups


//=============================================================================
// Properties
//=============================================================================

var() Sound RespawnSound;


//=============================================================================
// Variables
//=============================================================================

const TAU = 6.283185;
var float BobTimer;
var float BobOffset;
var float BobSpeed;
var Vector OriginalPrePivot;

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();
    BobTimer = FRand()*TAU;
    OriginalPrePivot = PrePivot;
}

auto simulated state Pickup
{

    simulated function Tick(float DeltaTime)
    {
        PrePivot.Z = OriginalPrePivot.Z + sin(Level.TimeSeconds * BobSpeed + BobTimer) * BobOffset;
    }

    function BeginState()
    {
        // GEm: Let the server ignore the tick
        if (Level.NetMode == NM_DedicatedServer)
            Disable('Tick');
        Super.BeginState();
    }

    function EndState()
    {
        // GEm: Reenable it after that, it's required for some effects
        if (Level.NetMode == NM_DedicatedServer)
            Enable('Tick');
        Super.EndState();
    }
}

simulated function PostNetReceive()
{
    // GEm: On clients, disable Tick when hidden
    if (bHidden)
        Disable('Tick');
    else
        Enable('Tick');
}

/*var TexPannerTriggered RespawnBuildGlow;
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
}*/


function RespawnEffect()
{
	PlaySound(RespawnSound);
}


state Sleeping
{
	/*function BeginState()
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
	}*/
	
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
    PickupSound = Sound'PickupHealthSmall'
    RespawnSound = Sound'RespawnHealth'
    TransientSoundVolume = 0.75
    TransientSoundRadius = 1000.0
    StaticMesh = StaticMesh'UT3PICKUPS_Mesh.Health_Small.S_Pickups_Health_Small'
    DrawScale = 1.0
    AmbientGlow = 77
    ScaleGlow = 1.0
    PickupMessage = "Health Vial +"
    RotationRate = (Yaw=32000)
    BobOffset = 5.0
    BobSpeed = 4.0
    RemoteRole = ROLE_SimulatedProxy
}

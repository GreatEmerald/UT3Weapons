/******************************************************************************
UT3Pickup

Creation date: 2008-07-20 11:48
Last change: $Id$
Copyright (c) 2008, 2013, 2014 Wormbo, GreatEmerald
******************************************************************************/

class UT3Pickup extends TournamentPickup notplaceable;


//=============================================================================
// Properties
//=============================================================================

var() Sound RespawnSound;
var() Sound SpawnedAmbientSound;


//=============================================================================
// Variables
//=============================================================================

var() Material PatternCombiner;
var() Material SpawnBand;
var() Material BasicTexture;
var TexPannerTriggered TriggerTexture;
var FinalBlend SpawnSkin;
var array<Material> TempSkins;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    // GEm: Create spawn-in effect materials
    if (SpawnBand != None && RespawnSound != None)
        TriggerTexture = class'UT3MaterialManager'.static.GetTriggerTexture(SpawnBand, GetSoundDuration(RespawnSound));
    if (TriggerTexture != None && PatternCombiner != None && BasicTexture != None)
        SpawnSkin = class'UT3MaterialManager'.static.GetSpawnSkin(TriggerTexture, PatternCombiner, BasicTexture);

    // GEm: Back up our default Skins
    TempSkins = Skins;
}


simulated function Destroyed()
{
    local int i;

    SpawnSkin = None;
    TriggerTexture = None;
    for (i = 0; i < TempSkins.Length; i++)
        TempSkins[i] = None;

    Super.Destroyed();
}


function RespawnEffect()
{
    PlaySound(RespawnSound, SLOT_Interact);
}


simulated function PostNetReceive()
{
    // GEm: Respawn effect related:
    if (!bHidden)
        GotoState('Pickup');
    else
        AmbientSound = None;
}


auto simulated state Pickup
{
    function BeginState()
    {
        Super.BeginState();
        if (UT3PickupFactory(PickUpBase) != None)
        {
            UT3PickupFactory(PickUpBase).PulseState = PS_Static;
            UT3PickupFactory(PickUpBase).StartPulse();
        }
    }

    function EndState()
    {
        Skins = TempSkins;
        AmbientSound = None;
        Super.EndState();
    }

Begin:
    CheckTouching();
    if (!bHidden)
        AmbientSound = SpawnedAmbientSound;

    if (SpawnSkin != None)
    {
        Skins[0] = SpawnSkin;
        TriggerTexture.Trigger(Self, None);
        Sleep(GetSoundDuration(RespawnSound));
    }
    Skins = TempSkins;
}


state Sleeping
{
    function BeginState()
    {
        Super.BeginState();
        if (Level.NetMode != NM_DedicatedServer)
            PostNetReceive();
        if (UT3PickupFactory(PickUpBase) != None)
        {
            UT3PickupFactory(PickUpBase).PulseState = PS_Off;
            UT3PickupFactory(PickUpBase).StartPulse();
        }
    }

    function EndState()
    {
        Super.EndState();
        if (Level.NetMode != NM_DedicatedServer)
            PostNetReceive();
    }

DelayedSpawn:
Begin:
    if (UT3PickupFactory(PickUpBase) != None)
    {
        Sleep(GetReSpawnTime() - UT3PickupFactory(PickUpBase).PulseThreshold);
        UT3PickupFactory(PickUpBase).PulseState = PS_Pulsing;
        UT3PickupFactory(PickUpBase).StartPulse();
        Sleep(UT3PickupFactory(PickUpBase).PulseThreshold);
    }
    else
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
    bNetNotify = True
    RemoteRole = ROLE_SimulatedProxy
    CollisionRadius = 40.0
    CollisionHeight = 44.0

    TransientSoundVolume = 1.0
    TransientSoundRadius = 1000.0
    SoundVolume = 200
    SoundRadius = 500.0

    //bWasHidden = True
    RespawnEffectTime = 0.0
    DrawType = DT_StaticMesh
    MessageClass = class'UT3PickupMessage'
    AmbientGlow = 77
}

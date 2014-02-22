//=============================================================================
// UT3HealthPickup.uc
// The base class for floaty health pickups
// Copyright © 2013, 2014 GreatEmerald
//=============================================================================

class UT3HealthPickup extends TournamentHealth;

// GEm: Bob-related variables
const TAU = 6.283185;
var float BobTimer;
var Vector BobBaseOffset;
var() float BobOffset;
var() float BobSpeed;
var() bool bFloatingPickup;
var() bool bRandomStart;

// GEm: Spawn effect-related variables
var() Sound RespawnSound;
/*var bool bWasHidden;
var TexPannerTriggered RespawnBuildGlow;*/
var() Material PatternCombiner;
var() Material SpawnBand;
var() Material BasicTexture;
var TexPannerTriggered TriggerTexture;
var FinalBlend SpawnSkin;
var array<Material> TempSkins;

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();
    // GEm: Set up bobbing start origin
    if (bFloatingPickup)
    {
        if (bRandomStart)
            BobTimer = FRand()*TAU;
        BobBaseOffset = PrePivot;
    }

    // GEm: Create spawn-in effect materials
    if (SpawnBand != None && RespawnSound != None)
        TriggerTexture = class'UT3MaterialManager'.static.GetTriggerTexture(SpawnBand, GetSoundDuration(RespawnSound));
    if (TriggerTexture != None && PatternCombiner != None && BasicTexture != None)
        SpawnSkin = class'UT3MaterialManager'.static.GetSpawnSkin(TriggerTexture, PatternCombiner, BasicTexture);

    // GEm: Back up our default Skins
    TempSkins = Skins;
}

auto simulated state Pickup
{
    simulated function Tick(float DeltaTime)
    {
        PrePivot.Z = BobBaseOffset.Z + sin(Level.TimeSeconds * BobSpeed + BobTimer) * BobOffset;
    }

    function BeginState()
    {
        Super.BeginState();
        // GEm: Let the server ignore the tick
        if (Level.NetMode == NM_DedicatedServer || !bFloatingPickup)
            Disable('Tick');
        if (UT3PickupFactory(PickUpBase) != None)
        {
            UT3PickupFactory(PickUpBase).PulseState = PS_Static;
            UT3PickupFactory(PickUpBase).StartPulse();
        }
    }

    simulated function EndState()
    {
        // GEm: Reenable it after that, it's required for some effects
        if (Level.NetMode == NM_DedicatedServer || !bFloatingPickup)
            Enable('Tick');

        // GEm: Reset skins to default, in case it's picked up before sleep is finished
        Skins = TempSkins;
        Super.EndState();
    }

// GEm: Use state time abilities to trigger and wait until the spawn effect is finished
Begin:
    if (SpawnSkin != None)
    {
        Skins[0] = SpawnSkin;
        TriggerTexture.Trigger(Self, None);
        Sleep(GetSoundDuration(RespawnSound));
    }
    Skins = TempSkins;
}

simulated function PostNetReceive()
{
    // GEm: On clients, disable Tick when hidden
    if (bHidden || !bFloatingPickup)
        Disable('Tick');
    else
        Enable('Tick');

    // GEm: Respawn effect related:
    if (!bHidden)
        GotoState('Pickup');
    /*if (!bHidden && bWasHidden) {
       RespawnBuildGlow.Trigger(Self, None);
    }
    bWasHidden = bHidden;*/
}


function RespawnEffect()
{
    PlaySound(RespawnSound, SLOT_Interact);
}

state Sleeping
{
    ignores Touch;

    function BeginState()
    {
        Super.BeginState();
        if (UT3PickupFactory(PickUpBase) != None)
        {
            UT3PickupFactory(PickUpBase).PulseState = PS_Off;
            UT3PickupFactory(PickUpBase).StartPulse();
        }
        /*if (Level.NetMode != NM_DedicatedServer)
            PostNetReceive();*/
    }

    /*function EndState()
    {
        Super.EndState();
        if (Level.NetMode != NM_DedicatedServer)
            PostNetReceive();
    }*/

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
    if (PickUpBase != None)
        PickUpBase.TurnOn();
    RespawnEffect();
    Sleep(RespawnEffectTime);
    GotoState('Pickup');
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

defaultproperties
{
    RespawnSound = Sound'UT3A_Pickups.Health.A_Pickups_Health_Respawn01'
    PatternCombiner = Material'UT3Pickups.Health_Small.PatternMultiply'
    SpawnBand = Material'UT3Pickups.Health_Small.SpawnBandTexCoord'
    //bWasHidden = true
    bNetNotify = true
    RespawnEffectTime = 0.0
    TransientSoundVolume = 0.75
    TransientSoundRadius = 1000.0
    AmbientGlow = 77
    ScaleGlow = 1.0
    MessageClass = class'UT3PickupMessage'
    RemoteRole = ROLE_SimulatedProxy
    Physics = PHYS_Rotating
    DrawType = DT_StaticMesh
}

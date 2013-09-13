//=============================================================================
// UT3HealthPickup.uc
// The base class for floaty health pickups
// Copyright © 2013 GreatEmerald
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
var bool bWasHidden;
var TexPannerTriggered RespawnBuildGlow;

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();
    if (bFloatingPickup)
    {
        if (bRandomStart)
            BobTimer = FRand()*TAU;
        BobBaseOffset = PrePivot;
    }
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

    function EndState()
    {
        // GEm: Reenable it after that, it's required for some effects
        if (Level.NetMode == NM_DedicatedServer || !bFloatingPickup)
            Enable('Tick');
        Super.EndState();
    }
}

simulated function PostNetReceive()
{
    // GEm: On clients, disable Tick when hidden
    if (bHidden || !bFloatingPickup)
        Disable('Tick');
    else
        Enable('Tick');

    // GEm: Respawn effect related:
    /*if (!bHidden && bWasHidden) {
       RespawnBuildGlow.Trigger(Self, None);
    }
    bWasHidden = bHidden;*/
}


function RespawnEffect()
{
    PlaySound(RespawnSound);
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
    RespawnEffect();
    Sleep(RespawnEffectTime);
    if (PickUpBase != None)
        PickUpBase.TurnOn();
    GotoState('Pickup');
}

defaultproperties
{
    RespawnSound = Sound'RespawnHealth'
    bWasHidden = true
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

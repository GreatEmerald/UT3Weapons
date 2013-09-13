//=============================================================================
// UT3PickupFactory.uc
// The base class of all UT3 pickup bases/chargers
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3PickupFactory extends xPickUpBase;

/** How fast does the base pulse */
var float BasePulseRate;

/** How much time left in the current pulse */
var float BasePulseTime;

/** This pickup base will begin pulsing when there are PulseThreshold seconds left
    before respawn. */
var float PulseThreshold;

enum EPulseState
{
    PS_Static,
    PS_Pulsing,
    PS_Off
};

var EPulseState PulseState, OldPulseState;

var bool bPulseFadeOut;
var bool bTickEnabled;

// GEm: Two decorative meshes for base pulsing
var UT3DecorativeMesh GlowBright;
var UT3DecorativeMesh GlowDim;
var() StaticMesh GlowStaticMesh;
var() array<Material> GlowBrightSkins;
var() array<Material> GlowDimSkins;
var() Vector GlowBrightScale;
var() Vector GlowDimScale;

var ConstantColor GlowConstantColour;
var() Color GlowColour;

var() array<Material> BaseBrightSkins;
var() array<Material> BaseDimSkins;

replication
{
    unreliable if (Role == ROLE_Authority)
        PulseState;
}

function SpawnPickup()
{
    if (myPickUp != None)
        myPickUp.Destroy();

    Super.SpawnPickup();

    if ( bDelayedSpawn && (myPickup != None))
    {
        if (myPickup.IsInState('Pickup'))
            myPickup.GotoState('WaitingForMatch');
        if (myPickup.myMarker != None)
            myPickup.myMarker.bSuperPickup = true;
    }
}

simulated function PreBeginPlay()
{
    Disable('Tick');
    OldPulseState = PulseState;
    Super.PreBeginPlay();
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if (!bHidden && Level.NetMode != NM_DedicatedServer
        && GlowStaticMesh != None)
    {
        GlowBright = Spawn(class'UT3DecorativeMesh');
        GlowBright.SetStaticMesh(GlowStaticMesh);
        GlowBright.SetDrawScale(DrawScale*1.25);
        GlowBright.SetDrawScale3D(GlowBrightScale);
        GlowBright.PrePivot = PrePivot;
        if (GlowBrightSkins.length > 0)
            GlowBright.Skins = GlowBrightSkins;
        GlowDim = Spawn(class'UT3DecorativeMesh');
        GlowDim.SetStaticMesh(GlowStaticMesh);
        GlowDim.SetDrawScale(DrawScale*1.25);
        GlowDim.SetDrawScale3D(GlowDimScale);
        GlowDim.PrePivot = PrePivot;
        if (GlowDimSkins.length > 0)
            GlowDim.Skins = GlowDimSkins;
        InitGlowMaterials();
    }
    if (bDelayedSpawn)
        PulseState = PS_Off;
    StartPulse();
}

simulated function InitGlowMaterials()
{
    local Combiner GlowGradientCombiner;
    local Combiner GlowPannerCombiner;
    local Shader GlowShader;

    GlowConstantColour = new(None) class'ConstantColor';
    GlowConstantColour.Color = GlowColour;

    GlowGradientCombiner = new(None) class'Combiner';
    GlowGradientCombiner.CombineOperation = CO_Multiply;
    GlowGradientCombiner.Material1 = Material'UT3Pickups.Health_Large.T_Pickups_Base_Health_Glow01';
    GlowGradientCombiner.Material2 = GlowConstantColour;

    GlowPannerCombiner = new(None) class'Combiner';
    GlowPannerCombiner.CombineOperation = CO_Multiply;
    GlowPannerCombiner.Material1 = GlowGradientCombiner;
    GlowPannerCombiner.Material2 = Material'UT3Pickups.Health_Large.Panner0';

    GlowShader = new(None) class'Shader';
    GlowShader.SelfIllumination = GlowPannerCombiner;
    GlowShader.OutputBlending = OB_Translucent;

    GlowBright.Skins[0] = GlowShader;
}

simulated function StartPulse()
{
    if (GlowConstantColour == None)
        return;
    log(self@"StartPulse"@PulseState@Level.TimeSeconds);

    // GEm: Pulsing effect management
    if (PulseState == PS_Pulsing)
    {
        Enable('Tick');
        bTickEnabled = true;
    }
    else
    {
        Disable('Tick');
        bTickEnabled = false;
        GlowConstantColour.Color = GlowColour;
    }

    // GEm: Glow effect management
    if (PulseState != PS_Off)
    {
        if (GlowBright != None)
            GlowBright.bHidden = false;
        if (myEmitter != None)
            myEmitter.bHidden = false;
        if (BaseBrightSkins.length > 0)
            Skins = BaseBrightSkins;
    }
    else
    {
        if (GlowBright != None)
            GlowBright.bHidden = true;
        if (myEmitter != None)
            myEmitter.bHidden = true;
        if (BaseDimSkins.length > 0)
            Skins = BaseDimSkins;
    }
}

simulated function Tick(float DeltaTime)
{
    if (!bTickEnabled)
        return;

    BasePulseTime += DeltaTime;
    if (BasePulseTime > BasePulseRate)
    {
        BasePulseTime -= BasePulseRate;
        bPulseFadeOut = !bPulseFadeOut;
    }
    if (bPulseFadeOut)
        GlowConstantColour.Color = GlowColour * ((BasePulseRate - BasePulseTime) / BasePulseRate);
    else
        GlowConstantColour.Color = GlowColour * (BasePulseTime / BasePulseRate);
}

simulated function PostNetReceive()
{
    if (GlowBright != None)
        GlowBright.SetRotation(Rotation);
    if (GlowDim != None)
        GlowDim.SetRotation(Rotation);
    if (OldPulseState != PulseState)
    {
        OldPulseState = PulseState;
        StartPulse();
    }
}

defaultproperties
{
    BasePulseRate = 0.5
    PulseThreshold = 5.0
    PulseState = PS_Static
    GlowColour = (A=255,R=255,G=255,B=255)
    bStatic = false
    AmbientGlow = 77
    DrawType = DT_StaticMesh
    GlowBrightScale = (X=1.0,Y=1.0,Z=1.0)
    GlowDimScale = (X=1.0,Y=1.0,Z=1.0)
    RemoteRole = ROLE_SimulatedProxy
    bNetNotify = true
    bAlwaysRelevant = true
}

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

// GEm: Two decorative meshes for base pulsing
var UT3DecorativeMesh GlowBright;
var UT3DecorativeMesh GlowDim;
var StaticMesh GlowStaticMesh;
var array<Material> GlowBrightSkins;
var array<Material> GlowDimSkins;
var Vector GlowBrightScale;
var Vector GlowDimScale;

var array<Material> BaseBrightSkins;
var array<Material> BaseDimSkins;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if (!bHidden && (Level.NetMode != NM_DedicatedServer)
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
    }
}

simulated function StartPulse(bool bBright, optional bool bPulseBase)
{
    if (bBright)
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

function SpawnPickup()
{
    log(self@"SpawnPickup: Called to spawn"@PowerUp);
    Super.SpawnPickup();
}

defaultproperties
{
    BasePulseRate = 0.5
    PulseThreshold = 5.0
    bStatic = false
    AmbientGlow = 77
    DrawType = DT_StaticMesh
    GlowBrightScale = (X=1.0,Y=1.0,Z=1.0)
    GlowDimScale = (X=1.0,Y=1.0,Z=1.0)
}

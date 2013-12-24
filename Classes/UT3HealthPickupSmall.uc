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

var() Material PatternCombiner;
var() Material SpawnBand;
var() Material BasicTexture;
var TexPannerTriggered TriggerTexture;
var FinalBlend SpawnSkin;
var array<Material> TempSkins;

simulated function PostBeginPlay()
{
    local Combiner EffectCombiner;
    local Shader SpawnShader;

    Super.PostBeginPlay();

    // GEm: Create a texture whose animation start we can control
    TriggerTexture = new(None) class'TexPannerTriggered'; // GEm: Must not forget to destroy objects
    TriggerTexture.Material = SpawnBand;
    TriggerTexture.PanRate = 1.1/GetSoundDuration(RespawnSound);
    TriggerTexture.StopAfterPeriod = 2.1 * TriggerTexture.PanRate;
    TriggerTexture.PanDirection = rot(0,-16384,0);

    // GEm: This combines the pattern effect with the spawn band
    EffectCombiner = new(None) class'Combiner';
    EffectCombiner.CombineOperation = CO_Add;
    EffectCombiner.AlphaOperation = AO_Use_Alpha_From_Material2;
    EffectCombiner.Material1 = PatternCombiner;
    EffectCombiner.Material2 = TriggerTexture;

    // GEm: Skin that we'll apply to the pickup while spawning
    SpawnShader = new(None) class'Shader';
    SpawnShader.Diffuse = BasicTexture;
    SpawnShader.Opacity = TriggerTexture;
    SpawnShader.Specular = EffectCombiner;
    SpawnShader.SpecularityMask = TriggerTexture;

    // GEm: Get a FinalBlend to solve Z-sort issues
    SpawnSkin = new(None) class'FinalBlend'; // GEm: Must not forget to destroy objects
    SpawnSkin.FrameBufferBlending = FB_AlphaBlend;
    SpawnSkin.Material = SpawnShader;
    //SpawnSkin.TwoSided = BasicTexture.bTwoSided;

    // GEm: Back up our default Skins
    TempSkins = Skins;
}

auto simulated state Pickup
{
    function EndState()
    {
        Skins = TempSkins;
        Super.EndState();
    }
Begin:
    Skins[0] = SpawnSkin;
    TriggerTexture.Trigger(Self, None);
    Sleep(GetSoundDuration(RespawnSound));
    Skins = TempSkins;
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

    PatternCombiner = Material'UT3Pickups.Health_Small.PatternMultiply'
    SpawnBand = Material'UT3Pickups.Health_Small.SpawnBandTexCoord'
    BasicTexture = Material'UT3Pickups.Health_Small.T_Pickups_Health_Small_D'
    //RespawnTime = 3.0 // GEm: DEBUG!!!
}

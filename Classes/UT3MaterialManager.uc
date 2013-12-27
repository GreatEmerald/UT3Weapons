/******************************************************************************
UT3MaterialManager

Creation date: 2008-07-19 15:38
Last change: $Id$
Copyright (c) 2008, 2013 Wormbo, GreatEmerald
******************************************************************************/

class UT3MaterialManager extends Object
    abstract;

// GEm: Leave only utility functions

static function TexPannerTriggered GetTriggerTexture(Material SpawnBand, float Duration)
{
    local TexPannerTriggered TriggerTexture;

    // GEm: Create a texture whose animation start we can control
    TriggerTexture = new(None) class'TexPannerTriggered';
    TriggerTexture.Material = SpawnBand;
    TriggerTexture.PanRate = 1.2/Duration;
    TriggerTexture.StopAfterPeriod = 2.1 * TriggerTexture.PanRate;
    TriggerTexture.PanDirection = rot(0,-16384,0);

    return TriggerTexture;
}

static function FinalBlend GetSpawnSkin(
    TexPannerTriggered TriggerTexture,
    Material PatternCombiner,
    Material BasicTexture)
{
    local Combiner EffectCombiner;
    local Shader SpawnShader;
    local FinalBlend SpawnSkin;

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

    return SpawnSkin;
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
}

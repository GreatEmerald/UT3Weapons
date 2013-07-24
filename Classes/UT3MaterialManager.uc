/******************************************************************************
UT3MaterialManager

Creation date: 2008-07-19 15:38
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3MaterialManager extends Inventory;


//=============================================================================
// Imports
//=============================================================================

#exec obj load file=Textures/include/Internal_MaterialManager.utx package=UT3Style
#exec obj load file=UCGeneric.utx
#exec obj load file=PickupSkins.utx
#exec obj load file=XGameTextures.utx


//=============================================================================
// Variables
//=============================================================================

var transient array<TexPannerTriggered> PannerPool;
var transient array<FinalBlend> GlassPool;
var transient array<FinalBlend> BubblesPool;
var transient array<FinalBlend> HealthPool;
var transient array<FinalBlend> UDamagePool;
var transient array<FinalBlend> ShieldPool;
var transient array<FinalBlend> TexturePool;

var private editconst int UniqueID;


/**
Returns an existing UT3MaterialManager instance or creates and registers a new
instance and returns that.

For performance reasons, the LevelInfo's Inventory chain is (ab)used as quick
access to an existing UT3MaterialManager instance.
*/
static function UT3MaterialManager GetMaterialManager(LevelInfo LI)
{
	local Inventory Inv;
	
	for (Inv = LI.Inventory; Inv != None; Inv = Inv.Inventory) {
		if (Inv.Class == default.Class)
			return UT3MaterialManager(Inv);
	}
	
	Inv = LI.Spawn(default.Class);
	if (Inv != None) {
		Inv.Inventory = LI.Inventory;
		LI.Inventory = Inv;
	}
	return UT3MaterialManager(Inv);
}


/**
Unregisters this UT3MaterialManager instance.
*/
function Destroyed()
{
	local Inventory Inv;
	
	if (Level.Inventory == Self) {
		Level.Inventory = Inventory;
	} else {
		for (Inv = Level.Inventory; Inv != None; Inv = Inv.Inventory) {
			if (Inv.Inventory == Self) {
				Inv.Inventory = Inventory;
				break;
			}
		}
	}
	Super.Destroyed();
}


function TexPannerTriggered GetSpawnEffectPanner(float EffectSpeed)
{
	local TexPannerTriggered SpawnEffectPanner;
	
	if (PannerPool.Length > 0) {
		SpawnEffectPanner = PannerPool[PannerPool.Length - 1];
		PannerPool.Length = PannerPool.Length - 1;
	}
	else {
		SpawnEffectPanner = new(None, "SpawnPanner" $ UniqueID) class'TexPannerTriggered';
		SpawnEffectPanner.Material        = TexScaler'SpawnEffectPosition';
		SpawnEffectPanner.PanRate         = EffectSpeed;
		SpawnEffectPanner.StopAfterPeriod = 2.1 * EffectSpeed;
		SpawnEffectPanner.PanDirection    = rot(0,-16384,0);
	}
	SpawnEffectPanner.Reset();
	
	return SpawnEffectPanner;
}

function ReleaseSpawnEffect(Material SpawnEffect)
{
	switch (Locs(Left(SpawnEffect.Name, 5))) {
	case "glass":
		GlassPool[GlassPool.Length] = FinalBlend(SpawnEffect);
		break;
	case "bubbl":
		BubblesPool[BubblesPool.Length] = FinalBlend(SpawnEffect);
		break;
	case "healt":
		HealthPool[HealthPool.Length] = FinalBlend(SpawnEffect);
		break;
	case "shiel":
		ShieldPool[ShieldPool.Length] = FinalBlend(SpawnEffect);
		break;
	case "udama":
		UDamagePool[UDamagePool.Length] = FinalBlend(SpawnEffect);
		break;
	case "textu":
		TexturePool[TexturePool.Length] = FinalBlend(SpawnEffect);
		break;
	case "spawn":
		PannerPool[PannerPool.Length] = TexPannerTriggered(SpawnEffect);
		break;
	}
}


function FinalBlend GetSpawnEffectGlass(TexPannerTriggered SpawnEffectPanner)
{
	local FinalBlend SpawnEffectFinal;
	local Combiner SpawnEffectCombiner, SpawnSpecularCombiner;
	local Shader SpawnEffectShader;
	
	if (GlassPool.Length > 0) {
		SpawnEffectFinal = GlassPool[GlassPool.Length - 1];
		GlassPool.Length = GlassPool.Length - 1;
		
		SpawnSpecularCombiner = Combiner(Shader(SpawnEffectFinal.Material).Specular);
		SpawnEffectCombiner   = Combiner(Shader(SpawnEffectFinal.Material).SelfIllumination);
	}
	else {
		SpawnEffectCombiner = new(None) class'Combiner';
		SpawnEffectCombiner.CombineOperation = CO_Add;
		SpawnEffectCombiner.AlphaOperation   = AO_Multiply;
		SpawnEffectCombiner.Material1        = Combiner'GlassOpacityCombiner';
		
		SpawnSpecularCombiner = new(None) class'Combiner';
		SpawnSpecularCombiner.CombineOperation = CO_AlphaBlend_With_Mask;
		SpawnSpecularCombiner.AlphaOperation   = AO_Use_Mask;
		SpawnSpecularCombiner.Material1        = Texture'UCGeneric.SolidColours.Black';
		SpawnSpecularCombiner.Material2        = Combiner'GlassOpacityCombiner';
		
		SpawnEffectShader = new(None) class'Shader';
		SpawnEffectShader.Specular         = SpawnSpecularCombiner;
		SpawnEffectShader.SpecularityMask  = Texture'PickupSkins.Health.BlueDot';
		SpawnEffectShader.SelfIllumination = SpawnEffectCombiner;
		
		SpawnEffectFinal = new(None, "GlassFinal" $ UniqueID++) class'FinalBlend';
		SpawnEffectFinal.FrameBufferBlending = FB_Brighten;
		SpawnEffectFinal.Material            = SpawnEffectShader;
	}
	SpawnSpecularCombiner.Mask = SpawnEffectPanner;
	
	SpawnEffectCombiner.Material2 = SpawnEffectPanner;
	
	return SpawnEffectFinal;
}


function FinalBlend GetSpawnEffectBubbles(TexPannerTriggered SpawnEffectPanner)
{
	local FinalBlend SpawnEffectFinal;
	local Combiner SpawnEffectCombiner;
	local Shader SpawnEffectShader;
	
	if (BubblesPool.Length > 0) {
		SpawnEffectFinal = BubblesPool[BubblesPool.Length - 1];
		BubblesPool.Length = BubblesPool.Length - 1;
		
		SpawnEffectShader   = Shader(SpawnEffectFinal.Material);
		SpawnEffectCombiner = Combiner(SpawnEffectShader.Diffuse);
	}
	else {
		SpawnEffectCombiner = new(None) class'Combiner';
		SpawnEffectCombiner.CombineOperation = CO_Add_With_Mask_Modulation;
		SpawnEffectCombiner.AlphaOperation   = AO_Use_Mask;
		SpawnEffectCombiner.Material1        = Combiner'XGameTextures.SuperPickups.MHBubblesC';
		
		SpawnEffectShader = new(None) class'Shader';
		SpawnEffectShader.Diffuse          = SpawnEffectCombiner;
		SpawnEffectShader.Specular         = Combiner'BubblesShineCombiner';
		SpawnEffectShader.SelfIllumination = SpawnEffectCombiner;
		
		SpawnEffectFinal = new(None, "BubblesFinal" $ UniqueID++) class'FinalBlend';
		SpawnEffectFinal.FrameBufferBlending = FB_Brighten;
		SpawnEffectFinal.Material            = SpawnEffectShader;
	}
	SpawnEffectShader.SpecularityMask = SpawnEffectPanner;
	
	SpawnEffectCombiner.Material2 = SpawnEffectPanner;
	SpawnEffectCombiner.Mask      = SpawnEffectPanner;
	
	return SpawnEffectFinal;
}


function FinalBlend GetSpawnEffectHealth(TexPannerTriggered SpawnEffectPanner)
{
	local FinalBlend SpawnEffectFinal;
	local Combiner SpawnEffectCombiner, SpawnSpecularCombiner;
	local Shader SpawnEffectShader;
	
	if (HealthPool.Length > 0) {
		SpawnEffectFinal = HealthPool[HealthPool.Length - 1];
		HealthPool.Length = HealthPool.Length - 1;
		
		SpawnEffectShader   = Shader(SpawnEffectFinal.Material);
		SpawnEffectCombiner = Combiner(SpawnEffectShader.Diffuse);
		SpawnSpecularCombiner = Combiner(SpawnEffectShader.Specular);
	}
	else {
		SpawnEffectCombiner = new(None) class'Combiner';
		SpawnEffectCombiner.CombineOperation = CO_Add_With_Mask_Modulation;
		SpawnEffectCombiner.AlphaOperation   = AO_Multiply;
		SpawnEffectCombiner.Material1        = Combiner'HealthCoreCombiner';
		
		SpawnSpecularCombiner = new(None) class'Combiner';
		SpawnSpecularCombiner.CombineOperation = CO_Add_With_Mask_Modulation;
		SpawnSpecularCombiner.AlphaOperation   = AO_Use_Mask;
		SpawnSpecularCombiner.Material1        = Combiner'PickupSkins.Shaders.Combiner1';
		
		SpawnEffectShader = new(None) class'Shader';
		SpawnEffectShader.Diffuse          = SpawnEffectCombiner;
		SpawnEffectShader.Opacity          = SpawnEffectCombiner;
		SpawnEffectShader.Specular         = SpawnSpecularCombiner;
		SpawnEffectShader.SelfIllumination = SpawnEffectCombiner;
		
		SpawnEffectFinal = new(None, "HealthFinal" $ UniqueID++) class'FinalBlend';
		SpawnEffectFinal.FrameBufferBlending = FB_Brighten;
		SpawnEffectFinal.Material            = SpawnEffectShader;
	}
	SpawnEffectShader.SpecularityMask = SpawnEffectPanner;
	
	SpawnEffectCombiner.Material2 = SpawnEffectPanner;
	SpawnEffectCombiner.Mask      = SpawnEffectPanner;
	
	SpawnSpecularCombiner.Material2 = SpawnEffectPanner;
	SpawnSpecularCombiner.Mask      = SpawnEffectPanner;
	
	return SpawnEffectFinal;
}


function FinalBlend GetSpawnEffectUDamage(TexPannerTriggered SpawnEffectPanner)
{
	local FinalBlend SpawnEffectFinal;
	local Combiner SpawnEffectCombiner;
	local Shader SpawnEffectShader;
	
	if (UDamagePool.Length > 0) {
		SpawnEffectFinal = UDamagePool[UDamagePool.Length - 1];
		UDamagePool.Length = UDamagePool.Length - 1;
		
		SpawnEffectCombiner = Combiner(Shader(SpawnEffectFinal.Material).SelfIllumination);
	}
	else {
		SpawnEffectCombiner = new(None) class'Combiner';
		SpawnEffectCombiner.CombineOperation = CO_Add_With_Mask_Modulation;
		SpawnEffectCombiner.AlphaOperation   = AO_Multiply;
		SpawnEffectCombiner.Material1        = Combiner'UDamageCombiner';
		
		SpawnEffectShader = new(None) class'Shader';
		SpawnEffectShader.SelfIllumination = SpawnEffectCombiner;
		
		SpawnEffectFinal = new(None, "UDamageFinal" $ UniqueID++) class'FinalBlend';
		SpawnEffectFinal.FrameBufferBlending = FB_AlphaBlend;
		SpawnEffectFinal.Material            = SpawnEffectShader;
	}
	SpawnEffectCombiner.Material2 = SpawnEffectPanner;
	SpawnEffectCombiner.Mask      = SpawnEffectPanner;
	
	return SpawnEffectFinal;
}


function FinalBlend GetSpawnEffectShield(TexPannerTriggered SpawnEffectPanner)
{
	local FinalBlend SpawnEffectFinal;
	local Combiner SpawnEffectCombiner;
	local Shader SpawnEffectShader;
	
	if (ShieldPool.Length > 0) {
		SpawnEffectFinal = ShieldPool[ShieldPool.Length - 1];
		ShieldPool.Length = ShieldPool.Length - 1;
		
		SpawnEffectCombiner = Combiner(Shader(SpawnEffectFinal.Material).SelfIllumination);
	}
	else {
		SpawnEffectCombiner = new(None) class'Combiner';
		SpawnEffectCombiner.CombineOperation = CO_Add_With_Mask_Modulation;
		SpawnEffectCombiner.AlphaOperation   = AO_Use_Mask;
		SpawnEffectCombiner.Material1        = TexRotator'PickupSkins.Shaders.TexRotator1';
		
		SpawnEffectShader = new(None) class'Shader';
		SpawnEffectShader.SelfIllumination = SpawnEffectCombiner;
		
		SpawnEffectFinal = new(None, "ShieldFinal" $ UniqueID++) class'FinalBlend';
		SpawnEffectFinal.FrameBufferBlending = FB_AlphaBlend;
		SpawnEffectFinal.Material            = SpawnEffectShader;
	}
	SpawnEffectCombiner.Material2 = SpawnEffectPanner;
	SpawnEffectCombiner.Mask      = SpawnEffectPanner;
	
	return SpawnEffectFinal;
}


function FinalBlend GetSpawnEffectTexture(TexPannerTriggered SpawnEffectPanner, Texture BaseTexture)
{
	local FinalBlend SpawnEffectFinal;
	local Shader SpawnEffectShader;
	
	if (TexturePool.Length > 0) {
		SpawnEffectFinal = TexturePool[TexturePool.Length - 1];
		GlassPool.Length = TexturePool.Length - 1;
		SpawnEffectShader = Shader(SpawnEffectFinal.Material);
	}
	else {
		SpawnEffectShader = new(None) class'Shader';
		
		SpawnEffectFinal = new(None, "TextureFinal" $ UniqueID++) class'FinalBlend';
		SpawnEffectFinal.FrameBufferBlending = FB_AlphaBlend;
		SpawnEffectFinal.Material            = SpawnEffectShader;
	}
	SpawnEffectShader.Diffuse = BaseTexture;
	SpawnEffectShader.Opacity = SpawnEffectPanner;
	SpawnEffectShader.Specular = SpawnEffectPanner;
	SpawnEffectShader.SpecularityMask = SpawnEffectPanner;
	
	SpawnEffectFinal.TwoSided = BaseTexture.bTwoSided;
	
	return SpawnEffectFinal;
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	RemoteRole = ROLE_None
}

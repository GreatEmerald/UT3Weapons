/******************************************************************************
UT3BaseGlowReplicationInfo

Creation date: 2008-07-18 12:27
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3BaseGlowReplicationInfo extends ReplicationInfo;


//=============================================================================
// Imports
//=============================================================================

//#exec texture import group=Skins file=Textures\HealthBaseLit.dds
//#exec texture import group=Skins file=Textures\PowerupBaseLit.dds
//#exec texture import group=Skins file=Textures\WeaponBaseLit.dds


//=============================================================================
// Properties
//=============================================================================

var() color GlowColor;
var() Material HealthBaseSkin, PowerupBaseSkin, WeaponBaseSkin;
var() float GlowChangePerSecond;


//=============================================================================
// Variables
//=============================================================================

var() editconst array<struct TGlowState {
	var xPickupBase Base;
	var float Time;
	var ConstantColor GlowColor;
}> GlowStates;

var() editconst struct TGlowUpdate {
	var xPickupBase Base;
	var float NewTime;
} GlowUpdateList[256];

var() editconst byte GlowUpdateNum, GlowUpdateLast;


//=============================================================================
// Replication
//=============================================================================

replication
{
	reliable if (bNetDirty || bNetInitial)
		GlowUpdateList, GlowUpdateNum;
}


auto simulated state Initializing
{
	simulated function Initialize()
	{
		local int i;
		local xPickupBase PB;

		foreach AllActors(class'xPickupBase', PB) {
			if (!PB.bHidden && PB.myPickup != None) {
				switch (PB.StaticMesh) {
				case class'NewHealthCharger'.default.StaticMesh:
					ProcessPickupBase(PB, i, HealthBaseSkin);
					break;
				case class'ShieldCharger'.default.StaticMesh:
					ProcessPickupBase(PB, i, PowerupBaseSkin);
					break;
				case class'NewWeaponBase'.default.StaticMesh:
					ProcessPickupBase(PB, i, WeaponBaseSkin);
					break;
				}
			}
		}
		bStasis = GlowStates.Length == 0;
	}

	simulated function ProcessPickupBase(xPickupBase PB, out int i, Material BaseSkin)
	{
		local Combiner GlowCombiner;
		local Shader GlowShader;
		local FinalBlend GlowFinal;

		if (i < ArrayCount(GlowUpdateList)) {
			GlowStates.Length = i + 1;

			GlowStates[i].Base = PB;

			if (Level.NetMode != NM_DedicatedServer) {
				GlowStates[i].GlowColor = new(None) class'ConstantColor';
				GlowStates[i].GlowColor.Color = GlowColor;

				GlowCombiner = new(None) class'Combiner';
				GlowCombiner.Material1 = BaseSkin;
				GlowCombiner.Material2 = GlowStates[i].GlowColor;
				GlowCombiner.CombineOperation = CO_Add;
				GlowCombiner.AlphaOperation = AO_Multiply;

				GlowShader = new(None) class'Shader';
				GlowShader.Diffuse = BaseSkin;
				GlowShader.SelfIllumination = GlowCombiner;
				GlowShader.SelfIlluminationMask = GlowCombiner;
				GlowShader.FallbackMaterial = BaseSkin;

				GlowFinal = new(None) class'FinalBlend';
				GlowFinal.Material = GlowShader;
				GlowFinal.FallbackMaterial = BaseSkin;

				if (PB.AmbientGlow == PB.default.AmbientGlow) {
					PB.AmbientGlow = 32;
				}
				PB.Skins.Length = 1;
				PB.Skins[0] = GlowFinal;
				PB.ResetStaticFilterState();
			}
			++i;
		}
	}

Begin:
	Initialize();
	GotoState('');
}


simulated function Tick(float DeltaTime)
{
	local int i;
	local byte TargetAlpha;

	if (GlowUpdateLast != GlowUpdateNum) {
		if (Level.NetMode == NM_Client) {
			do {
				++GlowUpdateLast;
				do {
					if (GlowStates[i].Base == GlowUpdateList[GlowUpdateLast].Base) {
						GlowStates[i].Time = GlowUpdateList[GlowUpdateLast].NewTime;
						break;
					}
				} until (++i == GlowStates.Length);
				i = 0;
			} until (GlowUpdateLast == GlowUpdateNum);
		} else {
			GlowUpdateLast = GlowUpdateNum;
		}
	}
	do {
		if (Level.NetMode == NM_Client) {
			if (GlowStates[i].Time < 10000 && GlowStates[i].Time > 0) {
				GlowStates[i].Time -= DeltaTime;
				if (GlowStates[i].Time < 0) {
					GlowStates[i].Time = 0;
				}
			}
		} else if (GlowStates[i].Base.myPickup == None || !GlowStates[i].Base.myPickup.IsInState('Sleeping') && !GlowStates[i].Base.myPickup.IsInState('Pickup')) {
			if (GlowStates[i].Time != 10000) {
				// update
				GlowUpdateNum++;
				GlowUpdateList[GlowUpdateNum].Base = GlowStates[i].Base;
				GlowUpdateList[GlowUpdateNum].NewTime = 10000;
			}
			GlowStates[i].Time = 10000;
		} else if (GlowStates[i].Base.myPickup.IsInState('Sleeping')) {
			if (GlowStates[i].Time ~= 10000 || GlowStates[i].Time < GlowStates[i].Base.myPickup.LatentFloat) {
				// update
				GlowUpdateNum++;
				GlowUpdateList[GlowUpdateNum].Base = GlowStates[i].Base;
				GlowUpdateList[GlowUpdateNum].NewTime = GlowStates[i].Base.myPickup.LatentFloat;
			}
			GlowStates[i].Time = GlowStates[i].Base.myPickup.LatentFloat;
		} else {
			if (GlowStates[i].Time > 0) {
				// update
				GlowUpdateNum++;
				GlowUpdateList[GlowUpdateNum].Base = GlowStates[i].Base;
				GlowUpdateList[GlowUpdateNum].NewTime = 0;
			}
			GlowStates[i].Time = 0;
		}
		if (GlowStates[i].Time > 5) {
			TargetAlpha = 0;
		} else if (GlowStates[i].Time == 0) {
			TargetAlpha = 255;
		} else {
			TargetAlpha = 500.0 * Abs(GlowStates[i].Time - int(GlowStates[i].Time) - 0.5);
		}
		if (TargetAlpha > GlowStates[i].GlowColor.Color.A) {
			GlowStates[i].GlowColor.Color.A -= Min(GlowStates[i].GlowColor.Color.A, (TargetAlpha - GlowStates[i].GlowColor.Color.A) * GlowChangePerSecond);
		} else if (TargetAlpha < GlowStates[i].GlowColor.Color.A) {
			GlowStates[i].GlowColor.Color.A += Min(GlowStates[i].GlowColor.Color.A, (GlowStates[i].GlowColor.Color.A - TargetAlpha) * GlowChangePerSecond);
		}
	} until (++i == GlowStates.Length || byte(GlowUpdateLast - GlowUpdateNum) == 255);
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	GlowColor = (R=64,G=64,B=64,A=255)
	GlowChangePerSecond = 500.0
	HealthBaseSkin  = Texture'2K4Chargers.ChargerTextures.HealthBaseTEX'//'HealthBaseLit'
	PowerupBaseSkin = Texture'XGameTextures.ShieldChargerTex'//'PowerupBaseLit'
	WeaponBaseSkin  = Texture'2K4Chargers.ChargerTextures.weaponBaseTEX'//'WeaponBaseLit'
}

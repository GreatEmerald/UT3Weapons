/******************************************************************************
UT3HellfireSPMAShellChild

Creation date: 2009-02-13 13:31
Last change: $Id$
Copyright (c) 2009, Wormbo
******************************************************************************/

class UT3HellfireSPMAShellChild extends ONSArtilleryShellSmall;


simulated function PostBeginPlay()
{
	local Rotator R;
	local PlayerController PC;

	if (!PhysicsVolume.bWaterVolume && Level.NetMode != NM_DedicatedServer) {
		PC = Level.GetLocalPlayerController();
		if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < 6000)
			Trail = Spawn(class'UT3HellfireSPMAChildTrail', self);
		Glow = Spawn(class'FlakGlow', self);
	}

	Super(Projectile).PostBeginPlay();
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
}


simulated function SpawnEffects(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

	PlaySound(ImpactSound, SLOT_None, 2.0);
	if (EffectIsRelevant(Location, false)) {
		PC = Level.GetLocalPlayerController();
		if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < 3000)
			Spawn(ExplosionEffectClass,,, HitLocation + HitNormal * 16);
		Spawn(ExplosionEffectClass,,, HitLocation + HitNormal * 16);
		if (ExplosionDecal != None && Level.NetMode != NM_DedicatedServer)
			Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
	}
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     ExplosionEffectClass=Class'UT3Style.UT3HellfireSPMAAirExplosion'
     AirExplosionEffectClass=Class'UT3Style.UT3HellfireSPMAAirExplosion'
     Damage=220.000000
     DamageRadius=500.000000
     ImpactSound=SoundGroup'UT3Style.SPMA.SPMAShellFragmentExplode'
     AmbientSound=None
     TransientSoundRadius=500.000000
}

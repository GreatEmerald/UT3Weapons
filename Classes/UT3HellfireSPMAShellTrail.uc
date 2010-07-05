/******************************************************************************
UT3HellfireSPMAShellTrail

Creation date: 2009-02-18 15:36
Latest change: $Id$
Copyright (c) 2009, Wormbo
******************************************************************************/

class UT3HellfireSPMAShellTrail extends ProjectileTrailEmitter;


//=============================================================================
// Imports
//=============================================================================

#exec texture import file=Textures\SPMASmoke.dds


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     VelocitySpawnInfo(0)=(ParticlesPerUU=0.040000)
     Begin Object Class=SpriteEmitter Name=SmokeTrail
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=20.000000)
         ColorScale(0)=(Color=(G=160,R=255))
         ColorScale(1)=(RelativeTime=0.010000,Color=(B=128,G=255,R=255,A=255))
         ColorScale(2)=(RelativeTime=0.200000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         Opacity=0.750000
         MaxParticles=500
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-50.000000,Max=50.000000))
         StartSizeRange=(X=(Min=30.000000,Max=40.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'UT3Style.SPMASmoke'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=2.000000,Max=2.500000)
         InitialDelayRange=(Min=0.100000,Max=0.100000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
     End Object
     Emitters(0)=SpriteEmitter'UT3Style.UT3HellfireSPMAShellTrail.SmokeTrail'

}

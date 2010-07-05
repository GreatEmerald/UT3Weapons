/******************************************************************************
UT3HellfireSPMAAirExplosion

Creation date: 2009-02-24 19:22
Last change: $Id$
Copyright (c) 2009, Wormbo
******************************************************************************/

class UT3HellfireSPMAAirExplosion extends Emitter;


//=============================================================================
// Imports
//=============================================================================

#exec obj load file=UT3SPMAEffects.usx package=UT3Style.SPMAEffects
#exec obj load file=VMParticleTextures.utx


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     Begin Object Class=MeshEmitter Name=FlashMesh
         StaticMesh=StaticMesh'UT3Style.SPMAEffects.SPMAAirExplosionMesh'
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(Z=(Max=1.000000))
         SizeScale(1)=(RelativeTime=0.150000,RelativeSize=2.000000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=0.180000,Max=1.800000),Y=(Min=2.400000,Max=2.400000),Z=(Min=2.400000,Max=2.400000))
         InitialParticlesPerSecond=1000.000000
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.225000,Max=0.225000)
     End Object
     Emitters(0)=MeshEmitter'UT3Style.UT3HellfireSPMAAirExplosion.FlashMesh'

     Begin Object Class=SpriteEmitter Name=ExplosionSprite
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         AddVelocityFromOwner=True
         MaxParticles=3
         StartLocationRange=(X=(Min=-10.000000,Max=3.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.050000,Max=0.050000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(1)=(RelativeTime=0.225000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=40.000000,Max=50.000000))
         InitialParticlesPerSecond=50.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'VMParticleTextures.VehicleExplosions.VMExp2_framesANIM'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.525000,Max=0.800000)
         AddVelocityMultiplierRange=(X=(Min=0.030000,Max=0.030000),Y=(Min=0.030000,Max=0.030000),Z=(Min=0.030000,Max=0.030000))
     End Object
     Emitters(1)=SpriteEmitter'UT3Style.UT3HellfireSPMAAirExplosion.ExplosionSprite'

     Begin Object Class=SpriteEmitter Name=GlowSprite
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         MaxParticles=1
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.300000,RelativeSize=2.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.800000)
         InitialParticlesPerSecond=1000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XEffects.GoldGlow'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.600000,Max=0.600000)
     End Object
     Emitters(2)=SpriteEmitter'UT3Style.UT3HellfireSPMAAirExplosion.GlowSprite'

     Begin Object Class=SpriteEmitter Name=Sparks
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=-1000.000000)
         ColorScale(0)=(RelativeTime=0.440000,Color=(B=192,G=192,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000)
         FadeOutStartTime=0.440000
         MaxParticles=15
         SizeScale(0)=(RelativeSize=8.000000)
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=2.250000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.200000)
         StartSizeRange=(X=(Min=0.500000,Max=10.000000),Y=(Min=3.000000,Max=10.000000),Z=(Min=0.500000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'UT3Style.SPMAEffects.SPMASpark'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.400000,Max=1.000000)
         StartVelocityRange=(X=(Min=200.000000,Max=700.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
     End Object
     Emitters(3)=SpriteEmitter'UT3Style.UT3HellfireSPMAAirExplosion.Sparks'

     AutoDestroy=True
     bNoDelete=False
     AmbientGlow=64
}

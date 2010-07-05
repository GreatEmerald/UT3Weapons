//-----------------------------------------------------------
//
//-----------------------------------------------------------
class UT3LeviathanShieldHitEffectBlue extends Emitter;

#exec OBJ LOAD FILE="..\Textures\AW-2004Particles.utx"
#exec OBJ LOAD FILE="..\Textures\AW-2k4XP.utx"

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'AW-2k4XP.Weapons.ShockShield'
         UseParticleColor=True
         UseColorScale=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=80,R=80))
         ColorScale(1)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSizeRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.750000,Max=0.750000))
         InitialParticlesPerSecond=5000.000000
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=MeshEmitter'UT3Style.UT3LeviathanShieldHitEffectBlue.MeshEmitter2'

     AutoDestroy=True
     bNoDelete=False
     AmbientGlow=254
}

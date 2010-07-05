//-----------------------------------------------------------
// UT3ScorpionBallProj2B.uc
// A very nice emitter effect for the ball.
// 2009, GreatEmerald
//-----------------------------------------------------------
class UT3ScorpionBallProj2B extends Emitter;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
         FadeIn=True
         SpinParticles=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeInEndTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         UseRotationFrom=PTRS_Offset
         SpinCCWorCW=(Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         LifetimeRange=(Min=99.000000,Max=99.000000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=99.000000
     End Object
     Emitters(0)=MeshEmitter'UT3Style.UT3ScorpionBallProj2B.MeshEmitter1'

     bNoDelete=False
     Skins(0)=Shader'XGameShaders.BRShaders.BombIconBS'
     bHardAttach=True
}

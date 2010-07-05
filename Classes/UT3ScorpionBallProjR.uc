//-----------------------------------------------------------
// UT3ScorpionBallProjR.uc
// A very nice emitter effect for the ball.
// 2009, GreatEmerald
//-----------------------------------------------------------
class UT3ScorpionBallProjR extends Emitter;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'WarEffectsMeshes.N_ball_M_jm'
         FadeIn=True
         UseRegularSizeScale=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeInEndTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSizeRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000),Z=(Min=0.600000,Max=0.600000))
         LifetimeRange=(Min=99.000000,Max=99.000000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=99.000000
     End Object
     Emitters(0)=MeshEmitter'UT3Style.UT3ScorpionBallProjR.MeshEmitter0'

     bNoDelete=False
     Skins(0)=Shader'XGameShadersB.TransB.TransRingRed'
     bHardAttach=True
}

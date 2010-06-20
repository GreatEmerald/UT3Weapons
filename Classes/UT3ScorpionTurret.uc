//-----------------------------------------------------------
// UT3ScorpionTurret.uc
// A great elecroball launcher.
// 2009, GreatEmerald
//-----------------------------------------------------------
class UT3ScorpionTurret extends EONSScorpionProjectileLauncher;

simulated function float MaxRange() //GE: Makes bots look further
{
    AimTraceRange = 7000;

    return AimTraceRange;
}

DefaultProperties
{
   RedSkin=Texture'VMWeaponsTX.RVgunGroup.RVnewGUNtex'
   BlueSkin=Texture'VMWeaponsTX.RVgunGroup.RVnewGUNtex'

   ProjectileClass=Class'UT3ScorpionBallRed'
   TeamProjectileClasses(0)=class'UT3ScorpionBallRed'
   TeamProjectileClasses(1)=class'UT3ScorpionBallBlue'
   FireSoundClass=Sound'UT3Vehicles.SCORPION.ScorpionFire'
   AIInfo(0)=(aimerror=650.000000,bTrySplash=True,bLeadTarget=True)
}

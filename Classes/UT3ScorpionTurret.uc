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

defaultproperties
{
     TeamProjectileClasses(0)=Class'UT3Style.UT3ScorpionBallRed'
     TeamProjectileClasses(1)=Class'UT3Style.UT3ScorpionBallBlue'
     RedSkin=Texture'VMWeaponsTX.RVgunGroup.RVnewGUNtex'
     BlueSkin=Texture'VMWeaponsTX.RVgunGroup.RVnewGUNtex'
     FireSoundClass=Sound'UT3Vehicles.SCORPION.ScorpionFire'
     ProjectileClass=Class'UT3Style.UT3ScorpionBallRed'
     AIInfo(0)=(bTrySplash=True,aimerror=650.000000)
}

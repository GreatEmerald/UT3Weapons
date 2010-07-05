//==============================================================================
// DamTypeUT3FlakShell.uc
// Dam!
// 2008, GreatEmerald
//==============================================================================

class DamTypeUT3FlakShell extends DamTypeUT3FlakShard
abstract;

defaultproperties
{
     DeathString="%o was ripped to shreds by %k's shrapnel."
     FemaleSuicide="%o blew herself up with a flak shell."
     MaleSuicide="%o blew himself up with a flak shell."
     bDetonatesGoop=True
     bThrowRagdoll=True
     GibPerterbation=0.250000
     VehicleMomentumScaling=3.000000
}

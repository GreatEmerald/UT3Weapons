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
    MaleSuicide="%o blew himself up with a flak shell."
    FemaleSuicide="%o blew herself up with a flak shell."

    GibPerterbation=0.25
    bDetonatesGoop=true
    bThrowRagdoll=true
    VehicleMomentumScaling=3.000000
}


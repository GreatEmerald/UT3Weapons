//==============================================================================
// DamTypeImpactEMP.uc
// EMP damage type.
// 2008, GreatEmerald
//==============================================================================

class DamTypeImpactEMP extends DamTypeShieldImpact;

defaultproperties
{
    DeathString="%k's Impact Hammer made a short circuit in %o's vehicle."
    MaleSuicide="%o managed to destroy his vehicle while being inside!"
    FemaleSuicide="%o managed to destroy her vehicle while being inside!"

    WeaponClass=class'UT3ImpactHammer'
}

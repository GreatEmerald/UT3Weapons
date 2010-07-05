//==============================================================================
// DamTypeImpactEMP.uc
// EMP damage type.
// 2008, GreatEmerald
//==============================================================================

class DamTypeImpactEMP extends DamTypeShieldImpact;

defaultproperties
{
     WeaponClass=Class'UT3Style.UT3ImpactHammer'
     DeathString="%k's Impact Hammer made a short circuit in %o's vehicle."
     FemaleSuicide="%o managed to destroy her vehicle while being inside!"
     MaleSuicide="%o managed to destroy his vehicle while being inside!"
}

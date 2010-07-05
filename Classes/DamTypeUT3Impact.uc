//==============================================================================
// DamTypeUT3Impact.uc
// Impact Hammer damage type.
// 2008, GreatEmerald
//==============================================================================

class DamTypeUT3Impact extends DamTypeShieldImpact;

defaultproperties
{
     WeaponClass=Class'UT3Style.UT3ImpactHammer'
     DeathString="%o was hammered by %k."
     FemaleSuicide="%o pounded herself."
     MaleSuicide="%o pounded himself."
     GibPerterbation=0.500000
     VehicleDamageScaling=0.200000
}

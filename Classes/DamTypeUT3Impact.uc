//==============================================================================
// DamTypeUT3Impact.uc
// Impact Hammer damage type.
// 2008, GreatEmerald
//==============================================================================

class DamTypeUT3Impact extends DamTypeShieldImpact;

defaultproperties
{
    DeathString="%o was hammered by %k."
    MaleSuicide="%o pounded himself."
    FemaleSuicide="%o pounded herself."

    WeaponClass=class'UT3ImpactHammer'
    VehicleDamageScaling=0.200000
    GibPerterbation=0.500000
}

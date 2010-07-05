//==============================================================================
// DamTypeUT3Enforcer.uc
// Weak.
// 2008, GreatEmerald
//==============================================================================

class DamTypeUT3Enforcer extends DamTypeAssaultBullet;

defaultproperties
{
     WeaponClass=Class'UT3Style.UT3Enforcer'
     DeathString="%k riddled %o full of holes with the Enforcer."
     FemaleSuicide="%o performed the impossible."
     MaleSuicide="%o performed the impossible."
     bInstantHit=True
     bFastInstantHit=True
     GibModifier=0.000000
     KDamageImpulse=200.000000
     VehicleDamageScaling=0.330000
     VehicleMomentumScaling=0.000000
}

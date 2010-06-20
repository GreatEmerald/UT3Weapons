//==============================================================================
// DamTypeUT3Enforcer.uc
// Weak.
// 2008, GreatEmerald
//==============================================================================

class DamTypeUT3Enforcer extends DamTypeAssaultBullet;

defaultproperties
{
    bRagdollBullet=true
    bBulletHit=true
    bFastInstantHit=true
    bInstantHit=true
    GibModifier=0.0
    DeathString="%k riddled %o full of holes with the Enforcer."
    MaleSuicide="%o performed the impossible."
    FemaleSuicide="%o performed the impossible."

    WeaponClass=class'UT3Enforcer'
    KDamageImpulse=200.000000
   VehicleDamageScaling=0.330000
   VehicleMomentumScaling=0.000000
}

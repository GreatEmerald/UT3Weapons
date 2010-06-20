//==============================================================================
// UT3DamTypeMinigun.uc
// Shards of destiny...
// 2008, GreatEmerald
//==============================================================================

class UT3DamTypeMinigun extends DamTypeMinigunBullet;

defaultproperties
{
    DeathString="%o was mowed down by %k's Stinger."
   FemaleSuicide="%o turned the Stinger on herself."
   MaleSuicide="%o turned the Stinger on himself."

    WeaponClass=class'UT3Minigun2v'
    VehicleDamageScaling=0.600000
    VehicleMomentumScaling=0.750000
    KDamageImpulse=200.000000
}

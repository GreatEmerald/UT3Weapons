//==============================================================================
// UT3DamTypeStingerShard.uc
// Tarydium, no idea why it does less damage to vehicles...
// 2008, GreatEmerald
//==============================================================================

class UT3DamTypeStingerShard extends WeaponDamageType
    abstract;

defaultproperties
{
     WeaponClass=Class'UT3Style.UT3Minigun2v'
     DeathString="%o was eviscerated by %k's Stinger."
     FemaleSuicide="%o turned the Stinger on herself."
     MaleSuicide="%o turned the Stinger on himself."
     bDelayedDamage=True
     bThrowRagdoll=True
     bBulletHit=True
     KDamageImpulse=1000.000000
     KDeathUpKick=200.000000
     VehicleDamageScaling=0.600000
     VehicleMomentumScaling=2.000000
}

//==============================================================================
// UT3ImpactHammerFire.uc
// Poosh!
// 2008, GreatEmerald
//==============================================================================
class UT3ImpactHammerFire extends UT3ImpactHammerEMPFire;


function DoFireEffect()
{
    Super(ShieldFire).DoFireEffect();
}

defaultproperties
{
     DamageType=Class'UT3Style.DamTypeUT3Impact'
     ShieldRange=55.000000
     MinForce=40000.000000
     MaxForce=100000.000000
     MinDamage=20.000000
     MaxDamage=140.000000
     SelfForceScale=1.200000
     MinSelfDamage=8.000000
     ChargingSound=Sound'UT3Weapons.ImpactHammer.ImpactHammerLoop'
     FireSound=Sound'UT3Weapons.ImpactHammer.ImpactHammerFire'
     FlashEmitterClass=Class'UT3Style.UT3ImpactEffect'
}

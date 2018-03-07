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
    WindingSound=Sound'UT3A_Weapon_ImpactHammer.UT3IHSingles.UT3IHFireStart01Cue'
    FireSound=Sound'UT3A_Weapon_ImpactHammer.UT3IHAltFire.UT3IHAltFireCue' 
    ChargingSound=Sound'UT3A_Weapon_ImpactHammer.UT3IHSingles.UT3IHFireLoop01Cue'
    TransientSoundVolume=1.5
    MinDamage=20.0
    MaxDamage=140.0
    ShieldRange=55.0 //110
    FullyChargedTime=2.5
    MinForce=40000.000000
    MaxForce=100000.000000
    MinSelfDamage=8.000000
    FireRate=1.1
    DamageType=class'DamTypeUT3Impact'
    SelfForceScale=1.200000
    SelfDamageScale=0.121
   
    PreFireAnim="WeaponCharge"
    FireAnim="WeaponFire"
     
    FlashEmitterClass=class'UT3ImpactEffect'

}

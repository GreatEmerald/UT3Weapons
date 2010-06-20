//==============================================================================
// UT3FlakChunk.uc
// Bouncy!
// 2008, GreatEmerald
//==============================================================================

class UT3FlakChunk extends FlakChunk;

defaultproperties
{
    Bounces=2
    ImpactSounds(0)=sound'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
    ImpactSounds(1)=sound'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
    ImpactSounds(2)=sound'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
    ImpactSounds(3)=sound'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
    ImpactSounds(4)=sound'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
    ImpactSounds(5)=sound'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
    Speed=3500.000000
    MaxSpeed=3500.000000
    Damage=18.000000
    MomentumTransfer=14000.000000
    LifeSpan=2.000000
    MyDamageType=class'DamTypeUT3FlakShard'
}

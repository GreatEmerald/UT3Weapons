//==============================================================================
// UT3FlakChunk.uc
// Bouncy!
// 2008, GreatEmerald
//==============================================================================

class UT3FlakChunk extends FlakChunk;

defaultproperties
{
     Bounces=2
     ImpactSounds(0)=SoundGroup'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
     ImpactSounds(1)=SoundGroup'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
     ImpactSounds(2)=SoundGroup'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
     ImpactSounds(3)=SoundGroup'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
     ImpactSounds(4)=SoundGroup'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
     ImpactSounds(5)=SoundGroup'UT3Weapons2.FlakCannon.FlakCannon_ImpactDirtCue'
     Speed=3500.000000
     MaxSpeed=3500.000000
     Damage=18.000000
     MomentumTransfer=14000.000000
     MyDamageType=Class'UT3Style.DamTypeUT3FlakShard'
     LifeSpan=2.000000
}

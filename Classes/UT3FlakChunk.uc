//==============================================================================
// UT3FlakChunk.uc
// Bouncy!
// 2008, GreatEmerald
//==============================================================================

class UT3FlakChunk extends FlakChunk;

#exec obj load file=UT3A_Weapon_FlakCannon.uax

defaultproperties
{
    Bounces=2
    ImpactSounds(0)=SoundGroup'UT3A_Weapon_FlakCannon.FireImpact.FireImpactCue'
    ImpactSounds(1)=SoundGroup'UT3A_Weapon_FlakCannon.FireImpact.FireImpactCue'
    ImpactSounds(2)=SoundGroup'UT3A_Weapon_FlakCannon.FireImpact.FireImpactCue'
    ImpactSounds(3)=SoundGroup'UT3A_Weapon_FlakCannon.FireImpact.FireImpactCue'
    ImpactSounds(4)=SoundGroup'UT3A_Weapon_FlakCannon.FireImpact.FireImpactCue'
    ImpactSounds(5)=SoundGroup'UT3A_Weapon_FlakCannon.FireImpact.FireImpactCue'
    TransientSoundVolume = 0.8
    Speed=3500.000000
    MaxSpeed=3500.000000
    Damage=18.000000
    MomentumTransfer=14000.000000
    LifeSpan=2.000000
    MyDamageType=class'DamTypeUT3FlakShard'
}

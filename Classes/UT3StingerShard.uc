//==============================================================================
// UT3StingerShard.uc
// Nailed 'em.
// 2008, GreatEmerald
//==============================================================================

class UT3StingerShard extends EliteKrallBolt; // HACK, but quite fits for now!

#exec obj load file=UT3Weapons2.uax

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    FinalBlend(Skins[0]).Material = TrailTex;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local xEmitter sparks;

    if ( EffectIsRelevant(Location,false) )
    {
        sparks = Spawn(class'LinkProjSparksYellow',,, HitLocation, rotator(HitNormal));
        sparks.Skins[0] = texture'Shock_Sparkle';
    }
    PlaySound(Sound'UT3Weapons2.Stinger.StingerHitEnemy');
    Destroy();
}

defaultproperties
{
     Speed=2500.000000
     MaxSpeed=4000.000000
     Damage=38.000000
     MyDamageType=Class'UT3Style.UT3DamTypeStingerShard'
     TransientSoundVolume=0.250000
}

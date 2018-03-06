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
    PlaySound(ImpactSound, Slot_None, 1.0);
    Destroy();
}

defaultproperties
{
    Drawscale=0.25
    LifeSpan=10.0
    //TrailTex=FinalBlend'UT3WeaponsT.Stinger.StingerMuzFlash'
    Damage=38
    MyDamageType=class'UT3DamTypeStingerShard'
    ImpactSound=Sound'UT3A_Weapon_Stinger.UT3SMFireImpact.UT3SMFireImpactCue'
    Speed=2500.000000
    MaxSpeed=4000.000000
}

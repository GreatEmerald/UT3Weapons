//==============================================================================
// UT3BioGlob.uc
// Hmmmmmmm... UT3 primary is ridiculous, but oh well...
// 2008, GreatEmerald
//==============================================================================

class UT3BioGlob extends BioGlob;

#exec obj load file=UT3A_Weapon_BioRifle.uax

defaultproperties
{
    bMergeGlobs=false //TODO: Make it optional
    ExplodeSound=Sound'UT3A_Weapon_BioRifle.FireImpactExplode.FireImpactExplodeCue'
    ImpactSound=Sound'UT3A_Weapon_BioRifle.FireImpactFizzle.FireImpactFizzleCue'
    TransientSoundVolume=0.920000
    MyDamageType=class'UT3DamTypeBioGlob'
    Skins(0)=FinalBlend'UT3WeaponSkins.BioBugzFluid'
    Damage=21.000000
    LifeSpan=12.000000
}


//==============================================================================
// UT3BioGlob.uc
// Hmmmmmmm... UT3 primary is ridiculous, but oh well...
// 2008, GreatEmerald
//==============================================================================

class UT3BioGlob extends BioGlob;

defaultproperties
{
    bMergeGlobs=false //TODO: Make it optional
    MyDamageType=class'UT3DamTypeBioGlob'
    Skins(0)=FinalBlend'UT3WeaponSkins.BioBugzFluid'
    ExplodeSound=Sound'UT3Weapons2.BioRifle.BioRifleExplode'
    ImpactSound=Sound'UT3Weapons2.BioRifle.BioRifleStick'
    Damage=21.000000
    LifeSpan=12.000000
}


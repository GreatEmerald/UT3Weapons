//==============================================================================
// UT3BioGlobCharged.uc
// This is for exact UT3 replcation.
// 2008, GreatEmerald
//==============================================================================

class UT3BioGlobCharged extends UT3BioGlob;

#exec obj load file=UT3A_Weapon_BioRifle.uax

defaultproperties
{
    bMergeGlobs=true
    ExplodeSound=Sound'UT3A_Weapon_BioRifle.FireAltImpactExplode.FireAltImpactExplodeCue'
    ImpactSound=Sound'UT3A_Weapon_BioRifle.FireImpactFizzle.FireImpactFizzleCue'
    TransientSoundVolume=0.920000
    LifeSpan=20.000000
}

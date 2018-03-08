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
    ExplodeSound=Sound'UT3A_Weapon_BioRifle.UT3BioFireAltImpactExplode.UT3BioFireAltImpactExplodeCue'
    ImpactSound=Sound'UT3A_Weapon_BioRifle.UT3BioFireImpactFizzle.UT3BioFireImpactFizzleCue'
    LifeSpan=20.000000
}

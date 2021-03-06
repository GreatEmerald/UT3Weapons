//==============================================================================
// UT3DamTypeBioGlob.uc
// Vehicles don't corrode.
// 2008, GreatEmerald
//==============================================================================

class UT3DamTypeBioGlob extends WeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was corroded by %k's Bio Rifle."
    MaleSuicide="%o was slimed by his own goop."
    FemaleSuicide="%o was slimed by her own goop."

    WeaponClass=class'UT3BioRifle'

    bKUseTearOffMomentum=false
    bDetonatesGoop=true
    bDelayedDamage=true

    DeathOverlayMaterial=Material'XGameShaders.PlayerShaders.LinkHit'
    VehicleDamageScaling=0.760000
}

//==============================================================================
// UT3DamTypeBioGlob.uc
// Vehicles don't corrode.
// 2008, GreatEmerald
//==============================================================================

class UT3DamTypeBioGlob extends WeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was slimed by %k's Bio Goo."
    FemaleSuicide="%o suffocated in her own Goo."
    MaleSuicide="%o suffocated in his own Goo."

    WeaponClass=class'UT3BioRifle'

    bKUseTearOffMomentum=false
    bDetonatesGoop=true
    bDelayedDamage=true

    DeathOverlayMaterial=Material'XGameShaders.PlayerShaders.LinkHit'
    VehicleDamageScaling=0.760000
}

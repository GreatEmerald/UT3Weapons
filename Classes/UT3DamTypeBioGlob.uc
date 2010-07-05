//==============================================================================
// UT3DamTypeBioGlob.uc
// Vehicles don't corrode.
// 2008, GreatEmerald
//==============================================================================

class UT3DamTypeBioGlob extends WeaponDamageType
    abstract;

defaultproperties
{
     WeaponClass=Class'UT3Style.UT3BioRifle'
     DeathString="%o was corroded by %k's Bio Rifle."
     FemaleSuicide="%o was slimed by her own goop."
     MaleSuicide="%o was slimed by his own goop."
     bDetonatesGoop=True
     bDelayedDamage=True
     DeathOverlayMaterial=Shader'XGameShaders.PlayerShaders.LinkHit'
     VehicleDamageScaling=0.760000
}

//==============================================================================
// DamTypeUT3ShockCombo.uc
// This could blow up small buildings.
// 2008, GreatEmerald
//==============================================================================

class DamTypeUT3ShockCombo extends DamTypeShockCombo;

defaultproperties
{
    WeaponClass=class'UT3ShockRifle'

    DamageOverlayMaterial=Material'UT2004Weapons.ShockHitShader'
    DamageOverlayTime=0.3

    KDamageImpulse=6500.000000
   VehicleDamageScaling=0.800000
   VehicleMomentumScaling=2.250000

}

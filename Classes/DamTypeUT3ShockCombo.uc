//==============================================================================
// DamTypeUT3ShockCombo.uc
// This could blow up small buildings.
// 2008, GreatEmerald
//==============================================================================

class DamTypeUT3ShockCombo extends DamTypeShockCombo;

defaultproperties
{
     WeaponClass=Class'UT3Style.UT3ShockRifle'
     DamageOverlayMaterial=Shader'UT2004Weapons.Shaders.ShockHitShader'
     DamageOverlayTime=0.300000
     KDamageImpulse=6500.000000
     VehicleDamageScaling=0.800000
     VehicleMomentumScaling=2.250000
}

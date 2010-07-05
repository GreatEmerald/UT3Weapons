//==============================================================================
// UT3EnforcerPickup.uc
// Yay, you can actually make it appear without hacks, unlike in UT3 :)
// 2008, GreatEmerald
//==============================================================================

class UT3EnforcerPickup extends AssaultRiflePickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3Enforcer'
     PickupMessage="Enforcer"
     PickupSound=Sound'UT3PickupSounds.Generic.EnforcerPickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3EnforcerPickup'
     Rotation=(Yaw=16384)
     DrawScale=1.000000
     PrePivot=(X=63.000000,Y=15.000000,Z=-45.000000)
     Skins(0)=Shader'UT3WeaponSkins.Enforcer.EnforcerShader'
     TransientSoundVolume=1.150000
}

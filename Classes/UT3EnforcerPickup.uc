//==============================================================================
// UT3EnforcerPickup.uc
// Yay, you can actually make it appear without hacks, unlike in UT3 :)
// 2008, GreatEmerald
//==============================================================================

class UT3EnforcerPickup extends AssaultRiflePickup;

defaultproperties
{
    InventoryType=class'UT3Enforcer'

    PickupMessage="Enforcer"
    PickupSound=Sound'UT3PickupSounds.Generic.EnforcerPickup'
    StaticMesh=StaticMesh'UT3WPStatics.UT3EnforcerPickup'
    PrePivot=(X=63.0,Y=15.0,Z=-45.0)
    DrawScale=1.0
    Rotation=(Yaw=16384)
    TransientSoundVolume=1.15
    Skins(0)=Shader'UT3WeaponSkins.Enforcer.EnforcerShader'
}


//==============================================================================
// UT3ShockRiflePickup.uc
// Nice sound this is.
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3ShockRiflePickup extends ShockRiflePickup;

defaultproperties
{
    InventoryType=class'UT3ShockRifle'

    PickupMessage="Shock Rifle"
    MessageClass = class'UT3PickupMessage'
    PickupSound=Sound'UT3PickupSounds.ShockRiflePickup'
    TransientSoundVolume=0.58

    StaticMesh=StaticMesh'UT3WPStatics.UT3ShockRiflePickup'
    PrePivot=(Y=23)
    DrawScale=1.1
    Skins(0)=Shader'UT3WeaponSkins.ShockRifle.ShockRifleSkin'
    Skins(1)=None
    StandUp=(X=0.25,Y=0.0,Z=0.25)
    AmbientGlow=77
}


//==============================================================================
// UT3ShockRiflePickup.uc
// Nice sound this is.
// 2008, GreatEmerald
//==============================================================================

class UT3ShockRiflePickup extends ShockRiflePickup;

defaultproperties
{
     StandUp=(X=0.250000,Y=0.000000,Z=0.250000)
     InventoryType=Class'UT3Style.UT3ShockRifle'
     PickupMessage="Shock Rifle"
     PickupSound=Sound'UT3PickupSounds.Generic.ShockRiflePickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3ShockRiflePickup'
     DrawScale=1.100000
     PrePivot=(Y=23.000000)
     Skins(0)=Shader'UT3WeaponSkins.ShockRifle.ShockRifleSkin'
     Skins(1)=None
     TransientSoundVolume=0.580000
}

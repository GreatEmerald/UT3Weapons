//==============================================================================
// UT3ShockAmmoPickup.uc
// Drakk Pod...
// 2008, GreatEmerald
//==============================================================================

class UT3ShockAmmoPickup extends ShockAmmoPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3ShockAmmo'
     PickupMessage="Shock Core"
     PickupSound=Sound'UT3PickupSounds.Generic.ShockCorePickup'
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.ShockRifleAmmo'
     DrawScale=1.500000
     DrawScale3D=(X=1.000000,Z=1.000000)
     PrePivot=(Z=22.000000)
     TransientSoundVolume=0.730000
}

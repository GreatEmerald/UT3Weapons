//==============================================================================
// UT3EnforcerAmmoPickup.uc
// Anyone..?
// 2008, GreatEmerald
//==============================================================================

class UT3EnforcerAmmoPickup extends AssaultAmmoPickup;

defaultproperties
{
     AmmoAmount=16
     InventoryType=Class'UT3Style.UT3EnforcerAmmo'
     PickupMessage="Enforcer Clip"
     PickupSound=Sound'UT3PickupSounds.Generic.EnforcerClipPickup'
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.EnforcerAmmo'
     DrawScale=1.500000
     PrePivot=(Z=11.000000)
     TransientSoundVolume=1.150000
}

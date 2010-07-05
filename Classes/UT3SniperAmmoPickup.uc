//=============================================================================
// UT3SniperAmmoPickup.uc
// It's always too low!
// 2008, GreatEmerald
//=============================================================================

class UT3SniperAmmoPickup extends ClassicSniperAmmoPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3SniperAmmo'
     PickupMessage="Sniper Shells"
     PickupSound=Sound'UT3PickupSounds.Generic.SniperAmmoPickup'
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.SniperRifleAmmo'
     DrawScale=1.500000
     PrePivot=(Z=11.000000)
     TransientSoundVolume=1.000000
}

//==============================================================================
// UT3BioAmmoPickup.uc
// Pack...
// 2008, GreatEmerald
//==============================================================================

class UT3BioAmmoPickup extends BioAmmoPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3BioAmmo'
     PickupMessage="Bio Rifle Ammo"
     PickupSound=Sound'UT3PickupSounds.Generic.BioSludgePickup'
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.BioRifleAmmo'
     DrawScale=1.700000
     PrePivot=(Z=-2.000000)
     TransientSoundVolume=1.150000
}

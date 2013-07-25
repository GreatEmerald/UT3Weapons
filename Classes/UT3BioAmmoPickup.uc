//==============================================================================
// UT3BioAmmoPickup.uc
// Pack...
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3BioAmmoPickup extends BioAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3BioAmmo'
    PickupMessage="Bio Rifle Ammo"
    PickupSound=Sound'UT3PickupSounds.BioSludgePickup'
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.BioRifleAmmo'
    DrawScale=1.875
    PrePivot=(Z=-2.0)
    TransientSoundVolume=1.15
}

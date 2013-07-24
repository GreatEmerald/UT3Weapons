//==============================================================================
// UT3LinkAmmoPickup.uc
// Hmm, I should also change the behaviour...
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3LinkAmmoPickup extends LinkAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3LinkAmmo'
    PickupMessage="Link Gun Ammo"
    PickupSound=Sound'UT3PickupSounds.Generic.LinkAmmoPickup'
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.LinkGunAmmo'
    DrawScale=1.6
    PrePivot=(Z=7.0)
}

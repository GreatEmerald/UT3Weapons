//==============================================================================
// UT3LinkAmmoPickup.uc
// Hmm, I should also change the behaviour...
// 2008, GreatEmerald
//==============================================================================

class UT3LinkAmmoPickup extends LinkAmmoPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3LinkAmmo'
     PickupMessage="Link Gun Ammo"
     PickupSound=Sound'UT3PickupSounds.Generic.LinkAmmoPickup'
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.LinkGunAmmo'
     DrawScale=1.600000
     PrePivot=(Z=7.000000)
}

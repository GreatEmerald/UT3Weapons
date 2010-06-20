//==============================================================================
// UT3LinkAmmoPickup.uc
// Hmm, I should also change the behaviour...
// 2008, GreatEmerald
//==============================================================================

class UT3LinkAmmoPickup extends LinkAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3LinkAmmo'
    PickupMessage="Link Gun Ammo"
    PickupSound=Sound'UT3PickupSounds.Generic.LinkAmmoPickup'
}

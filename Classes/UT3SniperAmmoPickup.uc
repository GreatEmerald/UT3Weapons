//=============================================================================
// UT3SniperAmmoPickup.uc
// It's always too low!
// 2008, GreatEmerald
//=============================================================================

class UT3SniperAmmoPickup extends ClassicSniperAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3SniperAmmo'

    PickupMessage="Sniper Shells"
    PickupSound=Sound'UT3PickupSounds.SniperAmmoPickup'
    TransientSoundVolume=1.0
}


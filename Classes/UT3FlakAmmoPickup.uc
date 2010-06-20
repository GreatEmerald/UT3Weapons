//==============================================================================
// UT3FlakAmmoPickup.uc
// Short file too.
// 2008, GreatEmerald
//==============================================================================

class UT3FlakAmmoPickup extends FlakAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3FlakAmmo'

    PickupMessage="Flak Shells"
    PickupSound=Sound'UT3PickupSounds.Generic.FlakAmmoPickup'
}

//=============================================================================
// UT3RocketAmmoPickup.uc
// Packs*2...
// 2008, GreatEmerald
//=============================================================================

class UT3RocketAmmoPickup extends RocketAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3RocketAmmo'

    PickupMessage="Rocket Pack"
    PickupSound=Sound'UT3PickupSounds.Generic.RocketPackPickup'
    TransientSoundVolume=0.6
}



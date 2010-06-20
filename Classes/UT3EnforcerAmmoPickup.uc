//==============================================================================
// UT3EnforcerAmmoPickup.uc
// Anyone..?
// 2008, GreatEmerald
//==============================================================================

class UT3EnforcerAmmoPickup extends AssaultAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3EnforcerAmmo'

    PickupMessage="Enforcer Clip"
    PickupSound=Sound'UT3PickupSounds.Generic.EnforcerClipPickup'
    TransientSoundVolume=1.15

    AmmoAmount=16
}

//==============================================================================
// UT3ShockAmmoPickup.uc
// Drakk Pod...
// 2008, GreatEmerald
//==============================================================================

class UT3ShockAmmoPickup extends ShockAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3ShockAmmo'
    PickupMessage="Shock Core"
    PickupSound=Sound'UT3PickupSounds.ShockCorePickup'
    TransientSoundVolume=0.73
    DrawScale=0.49
    DrawScale3D=(X=1,Y=1,Z=1)
}


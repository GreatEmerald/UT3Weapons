//=============================================================================
// UT3RocketAmmoPickup.uc
// Packs*2...
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//=============================================================================

class UT3RocketAmmoPickup extends RocketAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3RocketAmmo'

    PickupMessage="Rocket Pack"
    PickupSound=Sound'UT3PickupSounds.Generic.RocketPackPickup'
    TransientSoundVolume=0.6
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.RocketLauncherAmmo'
    DrawScale=1.600000
}



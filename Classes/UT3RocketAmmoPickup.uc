//=============================================================================
// UT3RocketAmmoPickup.uc
// Packs*2...
// 2008, GreatEmerald
//=============================================================================

class UT3RocketAmmoPickup extends RocketAmmoPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3RocketAmmo'
     PickupMessage="Rocket Pack"
     PickupSound=Sound'UT3PickupSounds.Generic.RocketPackPickup'
     StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.RocketLauncherAmmo'
     DrawScale=1.600000
     TransientSoundVolume=0.600000
}

//=============================================================================
// UT3SniperAmmoPickup.uc
// It's always too low!
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//=============================================================================

class UT3SniperAmmoPickup extends ClassicSniperAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3SniperAmmo'

    PickupMessage="Sniper Shells"
    PickupSound=Sound'UT3PickupSounds.SniperAmmoPickup'
    TransientSoundVolume=1.0
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.SniperRifleAmmo'
    DrawScale=1.500000
    PrePivot=(Z=11.000000)
    AmbientGlow=77
}


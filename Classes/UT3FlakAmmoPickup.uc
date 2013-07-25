//==============================================================================
// UT3FlakAmmoPickup.uc
// Short file too.
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3FlakAmmoPickup extends FlakAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3FlakAmmo'

    PickupMessage="Flak Shells"
    PickupSound=Sound'UT3PickupSounds.Generic.FlakAmmoPickup'
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.FlakCannonAmmo'
    DrawScale=2.0
    PrePivot=(Z=1.000000)
}

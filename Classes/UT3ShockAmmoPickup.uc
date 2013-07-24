//==============================================================================
// UT3ShockAmmoPickup.uc
// Drakk Pod...
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3ShockAmmoPickup extends ShockAmmoPickup;

defaultproperties
{
    InventoryType=class'UT3ShockAmmo'
    PickupMessage="Shock Core"
    PickupSound=Sound'UT3PickupSounds.ShockCorePickup'
    TransientSoundVolume=0.73
    DrawScale=1.5
    DrawScale3D=(X=1,Y=1,Z=1)
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.ShockRifleAmmo'
    PrePivot=(Z=22.000000)
}


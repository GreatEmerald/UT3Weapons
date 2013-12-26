//==============================================================================
// UT3MinigunAmmoPickup.uc
// A can of crystals?
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3MinigunAmmoPickup extends UT3AmmoPickup;

defaultproperties
{
    AmmoAmount=50
    InventoryType=class'UT3MinigunAmmo'

    PickupMessage="Stinger Shards"
    PickupSound=Sound'UT3PickupSounds.MiniAmmoPickup'
    PickupForce="MinigunAmmoPickup"
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.StingerAmmo'
    DrawScale=1.8
    PrePivot=(Z=2.0)
    CollisionHeight=12.750000
    HighlightSkins(0)=Material'UT3Pickups.Ammo_Stinger.Stinger_Highlight'
    PatternCombiner=Material'UT3WeaponSkins.Stinger.SpawnPatternMultiply'
    SpawnBand=Material'UT3WeaponSkins.Stinger.SpawnBandTexCoord'
    BasicTexture=Material'UT3WeaponSkins.Stinger.T_WP_Stinger_D'
}

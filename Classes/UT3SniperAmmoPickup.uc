//=============================================================================
// UT3SniperAmmoPickup.uc
// It's always too low!
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//=============================================================================

class UT3SniperAmmoPickup extends UT3AmmoPickup;

defaultproperties
{
    InventoryType=class'UT3SniperAmmo'

    PickupMessage="Sniper Shells"
    PickupSound=Sound'UT3PickupSounds.SniperAmmoPickup'
    TransientSoundVolume=1.0
    PickupForce="SniperAmmoPickup"
    AmmoAmount=10
    CollisionHeight=16.0
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.SniperRifleAmmo'
    DrawScale=1.500000
    PrePivot=(Z=11.000000)
    HighlightSkins(0)=Material'UT3Pickups.highlight.Sniper_Highlight'
    PatternCombiner=Material'UT3Pickups.Ammo_Enforcer.SpawnPatternMultiply'
    SpawnBand=Material'UT3Pickups.Ammo_Enforcer.SpawnBandTexCoord'
    BasicTexture=Material'UT3Pickups.Ammo.SniperRifle_D'
}


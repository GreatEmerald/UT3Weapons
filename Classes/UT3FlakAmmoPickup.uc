//==============================================================================
// UT3FlakAmmoPickup.uc
// Short file too.
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3FlakAmmoPickup extends UT3AmmoPickup;

defaultproperties
{
    AmmoAmount=10
    MaxDesireability=0.320000
    InventoryType=class'UT3FlakAmmo'

    PickupMessage="Flak Shells"
    PickupSound=Sound'UT3PickupSounds.Generic.FlakAmmoPickup'
    PickupForce="FlakAmmoPickup"
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.FlakCannonAmmo'
    DrawScale=2.0
    PrePivot=(Z=1.000000)
    CollisionHeight=8.250000
    HighlightSkins(0)=Material'UT3Pickups.Ammo_Flak.Flak_Highlight'
    PatternCombiner=Material'UT3Pickups.Ammo_Flak.SpawnPatternMultiply'
    SpawnBand=Material'UT3Pickups.Ammo_Flak.SpawnBandTexCoord'
    BasicTexture=Material'UT3Pickups.Ammo.Flakcannon_D'
}

//=============================================================================
// UT3AVRiLAmmoPickup.uc
// Yet I still need the class for referencing AVRiLAmmo.
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//=============================================================================

class UT3AVRiLAmmoPickup extends UT3AmmoPickup;

#exec obj load file=UT3Pickups.utx

DefaultProperties
{
    AmmoAmount=5
    InventoryType=class'UT3AVRiLAmmo' //what item to create in inventory (Epic comment)
    PickupMessage="Longbow AVRiL Ammo"
    PickupSound=Sound'UT3PickupSounds.Generic.FlakAmmoPickup'
    PickupForce="FlakAmmoPickup"
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.AVRILammo'
    DrawScale=1.8
    PrePivot=(Z=4.0)
    HighlightSkins(0)=Material'UT3Pickups.highlight.AVRIL_Highlight'
    PatternCombiner=Material'UT3WeaponSkins.AVRiL.SpawnPatternMultiply'
    SpawnBand=Material'UT3WeaponSkins.AVRiL.SpawnBandTexCoord'
    BasicTexture=Material'UT3WeaponSkins.AVRiL.T_WP_Avril_Ammo_D'
}

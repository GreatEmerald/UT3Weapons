//==============================================================================
// UT3ShockAmmoPickup.uc
// Drakk Pod...
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3ShockAmmoPickup extends UT3AmmoPickup;

defaultproperties
{
    AmmoAmount=10
    InventoryType=class'UT3ShockAmmo'
    PickupMessage="Shock Core"
    PickupSound=Sound'UT3PickupSounds.ShockCorePickup'
    TransientSoundVolume=0.73
    PickupForce="ShockAmmoPickup"
    DrawScale=1.8
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.ShockRifleAmmo'
    PrePivot=(Z=18.000000)
    CollisionHeight=32.0
    HighlightSkins(0)=Material'UT3Pickups.Ammo_Shock.Shock_Highlight'
    PatternCombiner=Material'UT3Pickups.Ammo_Shock.SpawnPatternMultiply'
    SpawnBand=Material'UT3Pickups.Ammo_Shock.SpawnBandTexCoord'
    BasicTexture=Material'UT3Pickups.Ammo_Shock.T_Ammo_ShockRifle_D'
}


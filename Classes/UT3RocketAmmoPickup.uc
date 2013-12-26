//=============================================================================
// UT3RocketAmmoPickup.uc
// Packs*2...
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//=============================================================================

class UT3RocketAmmoPickup extends UT3AmmoPickup;

simulated function PostBeginPlay()
{
    if (Rotation != default.Rotation)
        SetRotation(Rotation + default.Rotation);

    Super.PostBeginPlay();
}

defaultproperties
{
    AmmoAmount=9
    MaxDesireability=0.3
    InventoryType=class'UT3RocketAmmo'

    PickupMessage="Rocket Pack"
    PickupSound=Sound'UT3PickupSounds.Generic.RocketPackPickup'
    TransientSoundVolume=0.6
    PickupForce="RocketAmmoPickup"
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.RocketLauncherAmmo'
    DrawScale=1.8
    CollisionHeight=13.5
    Rotation=(Roll=49152)
    HighlightSkins(0)=Material'UT3Pickups.Ammo_Rockets.Rockets_Highlight'
    PatternCombiner=Material'UT3Pickups.Ammo_Rockets.SpawnPatternMultiply'
    SpawnBand=Material'UT3Pickups.Ammo_Rockets.SpawnBandTexCoord'
    BasicTexture=Material'UT3Pickups.Ammo.RocketLauncher_D'
}



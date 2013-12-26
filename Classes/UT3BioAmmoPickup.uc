//==============================================================================
// UT3BioAmmoPickup.uc
// Pack...
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3BioAmmoPickup extends UT3AmmoPickup;

simulated function PostBeginPlay()
{
    local actor HitActor;
    local vector HitLocation, HitNormal;

    Super.PostBeginPlay();

    // check to see if imbedded (stupid LD)
    HitActor = Trace(HitLocation, HitNormal, Location - CollisionHeight * vect(0,0,1), Location + CollisionHeight * vect(0,0,1), false);
    if ( (HitActor != None) && HitActor.bWorldGeometry )
        SetLocation(HitLocation + vect(0,0,1) * CollisionHeight);
}

defaultproperties
{
    AmmoAmount=20
    MaxDesireability=0.320000
    InventoryType=class'UT3BioAmmo'
    PickupMessage="Bio Rifle Ammo"
    PickupSound=Sound'UT3PickupSounds.BioSludgePickup'
    PickupForce="FlakAmmoPickup"
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.BioRifleAmmo'
    DrawScale=1.875
    PrePivot=(Z=-2.0)
    CollisionHeight=8.250000
    TransientSoundVolume=1.15
    HighlightSkins(0)=Material'UT3Pickups.Ammo_Bio.Bio_Highlight'
    PatternCombiner=Material'UT3Pickups.Ammo_Bio.SpawnPatternMultiply'
    SpawnBand=Material'UT3Pickups.Ammo_Bio.SpawnBandTexCoord'
    BasicTexture=Material'UT3WP_BioRifle_Materials.Materials.T_WP_BioRifle_D'
}

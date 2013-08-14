//==============================================================================
// UT3LinkAmmoPickup.uc
// Hmm, I should also change the behaviour...
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3LinkAmmoPickup extends UT3AmmoPickup;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    if ( Level.Game.bAllowVehicles )
        MaxDesireability *= 1.9;
}

defaultproperties
{
    AmmoAmount=50
    MaxDesireability=0.24
    InventoryType=class'UT3LinkAmmo'
    PickupMessage="Link Gun Ammo"
    PickupSound=Sound'UT3PickupSounds.Generic.LinkAmmoPickup'
    PickupForce="LinkAmmoPickup"
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.LinkGunAmmo'
    DrawScale=1.8
    PrePivot=(Z=7.0)
    CollisionHeight=10.5
    HighlightSkins(0)=Material'UT3Pickups.Ammo_Link.Link_Highlight'
}

//=============================================================================
// UT3SniperRiflePickup.uc
// It looks like a sniper, shoots like a sniper... It's a sniper.
// 2010, GreatEmerald
//=============================================================================

class UT3SniperRiflePickup extends ClassicSniperriflePickup;

defaultproperties
{
    InventoryType=class'UT3SniperRifle'
    PickupMessage="UT3 Sniper Rifle"
    PickupSound=Sound'UT3PickupSounds.Generic.SniperPickup'
    TransientSoundVolume=0.58
    
    StaticMesh=StaticMesh'UT3WPStatics.UT3SniperRiflePickup'
    PrePivot=(Y=19,Z=3)
    DrawScale=1.1

    MaxDesireability=0.630000
	  Skins(0)=Shader'UT3WeaponSkins.SniperRifle.SniperRifleSkinRed'
	  StandUp=(X=0.5,Y=0.0,Z=0.25)
}

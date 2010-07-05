//=============================================================================
// UT3SniperRiflePickup.uc
// It looks like a sniper, shoots like a sniper... It's a sniper.
// 2010, GreatEmerald
//=============================================================================

class UT3SniperRiflePickup extends ClassicSniperriflePickup;

defaultproperties
{
     StandUp=(X=0.500000,Z=0.250000)
     MaxDesireability=0.630000
     InventoryType=Class'UT3Style.UT3SniperRifle'
     PickupMessage="UT3 Sniper Rifle"
     PickupSound=Sound'UT3PickupSounds.Generic.sniperpickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3SniperRiflePickup'
     DrawScale=1.100000
     PrePivot=(Y=19.000000,Z=3.000000)
     Skins(0)=Shader'UT3WeaponSkins.SniperRifle.SniperRifleSkinRed'
     TransientSoundVolume=0.580000
}

//==============================================================================
// UT3FlakCannonPickup.uc
// I've got the Flak!
// 2008, 2013, 2014 GreatEmerald
//==============================================================================

class UT3FlakCannonPickup extends UT3WeaponPickup;

defaultproperties
{
    InventoryType=class'UT3FlakCannon'
    PickupForce="FlakCannonPickup"
    PickupMessage="Flak Cannon"
    MaxDesireability=+0.75

    PickupSound=Sound'UT3PickupSounds.Generic.FlakCannonPickup'
    TransientSoundVolume=1.0

    StaticMesh=StaticMesh'UT3WPStatics.UT3FlakPickup'
    DrawScale=0.55
    UV2Mode=UVM_LightMap
    Skins(0)=Shader'UT3WeaponSkins.FlakCannon.FlakCannon_Skin'
    StandUp=(X=0.25,Z=0.25)
}

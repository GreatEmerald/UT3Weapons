//==============================================================================
// UT3FlakCannonPickup.uc
// I've got the Flak!
// 2008, GreatEmerald
//==============================================================================

class UT3FlakCannonPickup extends FlakCannonPickup;

defaultproperties
{
     InventoryType=Class'UT3Style.UT3FlakCannon'
     PickupMessage="Flak Cannon"
     PickupSound=Sound'UT3PickupSounds.Generic.FlakCannonPickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3FlakPickup'
     Skins(0)=Shader'UT3WeaponSkins.FlakCannon.FlakCannon_Skin'
     UV2Mode=UVM_LightMap
     TransientSoundVolume=1.000000
}

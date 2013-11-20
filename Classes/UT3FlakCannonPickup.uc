//==============================================================================
// UT3FlakCannonPickup.uc
// I've got the Flak!
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3FlakCannonPickup extends FlakCannonPickup;

defaultproperties
{
    InventoryType=class'UT3FlakCannon'

    PickupMessage="Flak Cannon"
    MessageClass = class'UT3PickupMessage'
    PickupSound=Sound'UT3PickupSounds.Generic.FlakCannonPickup'
    TransientSoundVolume=1.0

     StaticMesh=StaticMesh'UT3WPStatics.UT3FlakPickup'
     UV2Mode=UVM_LightMap
     Skins(0)=Shader'UT3WeaponSkins.FlakCannon.FlakCannon_Skin'
     AmbientGlow=77
}

//==============================================================================
// UT3MinigunPickup.uc
// Take it!
// 2008, 2013, 2014 GreatEmerald
//==============================================================================

class UT3MinigunPickup extends UT3WeaponPickup;

#exec OBJ LOAD FILE=UT3WeaponSkins.utx
#exec OBJ LOAD FILE=UT3WPStatics.usx

defaultproperties
{
    InventoryType=class'UT3Minigun2v'

    PickupMessage="Stinger Minigun"
    PickupSound=Sound'UT3PickupSounds.FlakShellPickup'
    StaticMesh=StaticMesh'UT3WPStatics.UT3StingerPickup'
    DrawScale=0.5
    PrePivot=(X=-40)
    DesiredRotation=(Yaw=0)
    Skins(0)=Shader'UT3WeaponSkins.Stinger.StingerSkin'
    StandUp=(X=0.75)
    MaxDesireability=+0.73
    PickupForce="MinigunPickup"
}

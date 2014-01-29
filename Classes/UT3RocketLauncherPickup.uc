//=============================================================================
// UT3RocketLauncherPickup.uc
// Got it.
// 2008, 2013, 2014 GreatEmerald
//=============================================================================

class UT3RocketLauncherPickup extends UT3WeaponPickup;

#exec OBJ LOAD FILE=UT3WeaponSkins.utx
#exec OBJ LOAD FILE=UT3WPStatics.usx

defaultproperties
{
    InventoryType=class'UT3RocketLauncher'

    PickupMessage="Rocket Launcher"
    PickupSound=Sound'UT3PickupSounds.Generic.RocketLauncherPickup'
    TransientSoundVolume=0.6
    StaticMesh=StaticMesh'UT3WPStatics.UT3RocketLauncherPickup'
    PrePivot=(Y=18,Z=5)
    DrawScale=1.5
    Skins(0)=Shader'UT3WeaponSkins.RocketLauncher.RocketLauncherSkin'
    StandUp=(X=0.25,Y=0.0,Z=0.25)
    PickupForce="RocketLauncherPickup"
    MaxDesireability=+0.78
}

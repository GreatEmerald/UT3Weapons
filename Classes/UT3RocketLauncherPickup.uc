//=============================================================================
// UT3RocketLauncherPickup.uc
// Got it.
// 2008, GreatEmerald
//=============================================================================

class UT3RocketLauncherPickup extends RocketLauncherPickup;

#exec OBJ LOAD FILE=UT3WeaponSkins.utx
#exec OBJ LOAD FILE=UT3WPStatics.usx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Shader'UT3WeaponSkins.RocketLauncher.RocketLauncherSkin');
    L.AddPrecacheStaticMesh(StaticMesh'UT3WPStatics.UT3RocketLauncherPickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Shader'UT3WeaponSkins.RocketLauncher.RocketLauncherSkin');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     StandUp=(Z=0.250000)
     InventoryType=Class'UT3Style.UT3RocketLauncher'
     PickupMessage="Rocket Launcher"
     PickupSound=Sound'UT3PickupSounds.Generic.RocketLauncherPickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3RocketLauncherPickup'
     DrawScale=1.500000
     PrePivot=(Y=18.000000,Z=5.000000)
     Skins(0)=Shader'UT3WeaponSkins.RocketLauncher.RocketLauncherSkin'
     TransientSoundVolume=0.600000
}

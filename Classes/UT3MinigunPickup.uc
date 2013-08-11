//==============================================================================
// UT3MinigunPickup.uc
// Take it!
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3MinigunPickup extends MinigunPickup;

#exec OBJ LOAD FILE=UT3WeaponSkins.utx
#exec OBJ LOAD FILE=UT3WPStatics.usx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Shader'UT3WeaponSkins.Stinger.StingerSkin');
    L.AddPrecacheStaticMesh(StaticMesh'UT3WPStatics.UT3StingerPickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Shader'UT3WeaponSkins.Stinger.StingerSkin');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    InventoryType=class'UT3Minigun2v'

    PickupMessage="Stinger Minigun"
    PickupSound=Sound'UT3PickupSounds.FlakShellPickup'
    StaticMesh=StaticMesh'UT3WPStatics.UT3StingerPickup'
    PrePivot=(X=-40)
    DesiredRotation=(Yaw=0)
    Skins(0)=Shader'UT3WeaponSkins.Stinger.StingerSkin'
    AmbientGlow=77
    
}

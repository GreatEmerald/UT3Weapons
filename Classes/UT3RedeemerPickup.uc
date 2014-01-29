//=============================================================================
// UT3RedeemerPickup.uc
// Woah it's big.
// 2008, 2013, 2014 GreatEmerald
//=============================================================================

class UT3RedeemerPickup extends UT3WeaponPickup;

function PrebeginPlay()
{
    Super.PreBeginPlay();
    if ( Level.Game.IsA('xMutantGame') )
        Destroy();
}

function SetWeaponStay()
{
    bWeaponStay = false;
}

function float GetRespawnTime()
{
    return ReSpawnTime;
}

defaultproperties
{
    InventoryType=class'UT3Redeemer'

    PickupMessage="Redeemer"
    PickupSound=Sound'UT3PickupSounds.Generic.RedeemerPickup'
    TransientSoundVolume=0.73
    StaticMesh=StaticMesh'UT3WPStatics.UT3RedeemerPickup'
    DrawScale=0.9
    Skins(0)=Shader'UT3WeaponSkins.Redeemer.RedeemerSkin'
    Skins(1)=Shader'UT3WeaponSkins.Redeemer.RedeemerLauncher'
    PickupForce="FlakCannonPickup"
    MaxDesireability=+1.0
    RespawnTime=120.0
    bWeaponStay=false
}

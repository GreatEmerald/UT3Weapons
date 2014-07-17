//=============================================================================
// UT3WeaponPickupFactory.uc
// The weapon-spawning base
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3WeaponPickupFactory extends UT3PickupFactory;

var() class<Weapon> WeaponType;

function bool CheckForErrors()
{
        if ( (WeaponType == None) || WeaponType.static.ShouldBeHidden() )
        {
                warn(self$" ILLEGAL WEAPONTYPE "$Weapontype);
                return true;
        }
        return Super.CheckForErrors();
}

function byte GetInventoryGroup()
{
        if (WeaponType != None)
                return WeaponType.Default.InventoryGroup;
        return 999;
}

simulated function PostBeginPlay()
{
    //log(self@"PostBeginPlay when myPickUp is"@myPickUp@"and PowerUp is"@PowerUp);
    if (WeaponType != None)
    {
        PowerUp = WeaponType.default.PickupClass;
        if ( WeaponType.Default.InventoryGroup == 0 )
            bDelayedSpawn = true;
    }
    Super.PostBeginPlay();
}

function WeaponChanged()
{
    if (WeaponType != None)
    {
        PowerUp = WeaponType.default.PickupClass;
        if ( WeaponType.Default.InventoryGroup == 0 )
            bDelayedSpawn = true;
    }
    SpawnPickup();
}

defaultproperties
{
    StaticMesh = StaticMesh'UT3PICKUPS_Mesh.WeaponBase.S_Pickups_WeaponBase'
    SpawnHeight = 44.0
    GlowStaticMesh = StaticMesh'UT3PICKUPS_Mesh.Health_Large.S_Pickups_Base_HealthGlow01'
    GlowBrightSkins(0) = Material'UT3Pickups.WeaponBase.M_Pickups_WeaponBase_Glow'
    GlowDimSkins(0) = Material'UT3Pickups.WeaponBase.M_Pickups_WeaponBase_Glow_Dim'
    GlowBrightScale = (X=1.35,Y=0.78)
    GlowDimScale = (X=1.35,Y=0.78)
    GlowColour = (R=120,G=108,B=27)
}

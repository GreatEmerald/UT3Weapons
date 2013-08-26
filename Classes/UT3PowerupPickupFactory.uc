//=============================================================================
// UT3PowerupPickupFactory.uc
// The superclass of powerup (UDamage, Invisibility etc.) bases
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3PowerupPickupFactory extends UT3PickupFactory
    abstract;

defaultproperties
{
    bDelayedSpawn = true
    SpawnHeight = 44.0
    StaticMesh = StaticMesh'UT3PICKUPS_Mesh.Base_Powerup.S_Pickups_Base_Powerup01'
    PrePivot = (Z=5.0)
}

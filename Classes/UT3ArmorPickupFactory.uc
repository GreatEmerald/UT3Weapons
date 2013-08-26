//=============================================================================
// UT3ArmorPickupFactory.uc
// The base class for all the armour bases
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3ArmorPickupFactory extends UT3PickupFactory
    abstract;

defaultproperties
{
    bDelayedSpawn = true
    StaticMesh = StaticMesh'UT3PICKUPS_Mesh.Base_Armor.S_Pickups_Base_Armor'
    DrawScale = 1.0
    // GEm: TODO: add particles
    SpawnHeight = 44.0
    PrePivot = (Z=5.0)
}

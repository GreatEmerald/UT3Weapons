/******************************************************************************
UT3ArmorThighPads

Creation date: 2008-07-15 11:40
Last change: $Id$
Copyright (c) 2008, 2010, 2013 Wormbo, 100GPing100, GreatEmerald
******************************************************************************/

class UT3ArmorThighPads extends UT3Armor;

#exec OBJ LOAD FILE=UT3Pickups.utx
#exec OBJ LOAD FILE=UT3Pickups-SM.usx


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    //PickupClass = class'UT3ArmorThighPadsPickup'
    Charge=30
    ArmorAbsorption=50
    AbsorptionPriority=30
    StaticMesh=StaticMesh'UT3Pickups-SM.Powerups.ThighPads'
    Skin=Shader'UT3Pickups.ThighPads.ThighPadsSkin'
}

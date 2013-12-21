/******************************************************************************
UT3ArmorShieldbeltPickup

Creation date: 2008-07-19 18:45
Last change: $Id$
Copyright (c) 2008, 2010, 2013 Wormbo, 100GPing100, GreatEmerald
******************************************************************************/

class UT3ArmorShieldbeltPickup extends UT3ArmorPickup;


//=============================================================================
// Imports
//=============================================================================


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    RespawnTime   = 60.0
    MaxDesireability = 1.5
    InventoryType = class'UT3ArmorShieldbelt'
    PickupSound   = Sound'UT3PickupSounds.Generic.ShieldbeltPickup'
    PickupMessage = "Shield Belt"
    PickupForce   = "LargeShieldPickup"
    StaticMesh    = StaticMesh'UT3Pickups-SM.Powerups.ShieldBelt'
    Physics       = PHYS_Rotating
    RotationRate  = (Yaw=24000)
    DrawScale     = 1.5
    PrePivot      = (Z=10.000000)
    Skins(0)      = Shader'UT3Pickups.ShieldBelt.ShieldBeltSkin'
}

/******************************************************************************
UT3ArmorVestPickup

Creation date: 2008-07-19 18:45
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3ArmorVestPickup extends UT3ArmorPickup;


//=============================================================================
// Imports
//=============================================================================

#exec audio import file=Sounds\PickupArmorChest.wav group=Pickups


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     InventoryType=Class'UT3Style.UT3ArmorVest'
     PickupMessage="Armor Vest"
     PickupSound=Sound'UT3Style.Pickups.PickupArmorChest'
     PickupForce="ShieldPack"
     StaticMesh=StaticMesh'UT3Pickups-SM.Powerups.Vest'
     Physics=PHYS_Rotating
     DrawScale=0.800000
     Skins(0)=Shader'UT3Pickups.Vest.VestSkin'
     RotationRate=(Yaw=24000)
}

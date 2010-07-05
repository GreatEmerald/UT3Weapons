/******************************************************************************
UT3ArmorShieldbeltPickup

Creation date: 2008-07-19 18:45
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3ArmorShieldbeltPickup extends UT3ArmorPickup;


//=============================================================================
// Imports
//=============================================================================

#exec audio import file=Sounds\PickupArmorShieldbelt.wav group=Pickups


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     MaxDesireability=1.500000
     InventoryType=Class'UT3Style.UT3ArmorShieldbelt'
     RespawnTime=60.000000
     PickupMessage="Shield Belt"
     PickupSound=Sound'UT3Style.Pickups.PickupArmorShieldbelt'
     PickupForce="LargeShieldPickup"
     StaticMesh=StaticMesh'UT3Pickups-SM.Powerups.ShieldBelt'
     Physics=PHYS_Rotating
     DrawScale=1.600000
     PrePivot=(Z=10.000000)
     Skins(0)=Shader'UT3Pickups.ShieldBelt.ShieldBeltSkin'
     RotationRate=(Yaw=24000)
}

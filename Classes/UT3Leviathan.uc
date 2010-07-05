/*******************************************************************************
UT3Leviathan

Creation date: 2007-12-30 13:00
Last change: $Id$
Copyright (c) 2007 and 2009, Wormbo and GreatEmerald
*******************************************************************************/

class UT3Leviathan extends ONSMobileAssaultStation;


//=============================================================================
// Variables
//=============================================================================



//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     ChassisTorqueScale=0.200000
     MaxSteerAngleCurve=(Points=((OutVal=30.000000),(InVal=0.000000,OutVal=20.000000)))
     MaxBrakeTorque=8.000000
     SteerSpeed=50.000000
     DriverWeapons(0)=(WeaponClass=Class'UT3Style.UT3LeviathanDriverWeapon')
     PassengerWeapons(0)=(WeaponPawnClass=Class'UT3Style.UT3LeviathanTurretBeam')
     PassengerWeapons(1)=(WeaponPawnClass=Class'UT3Style.UT3LeviathanTurretRocket')
     PassengerWeapons(2)=(WeaponPawnClass=Class'UT3Style.UT3LeviathanTurretStinger')
     PassengerWeapons(3)=(WeaponPawnClass=Class'UT3Style.UT3LeviathanTurretShock')
     VehicleNameString="UT3 Leviathan"
     Health=6500
     CollisionHeight=100.000000
}

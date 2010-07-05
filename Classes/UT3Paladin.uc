/******************************************************************************
UT3Paladin

Creation date: 2008-05-02 20:51
Last change since: Alpha 2
Copyright (c) 2008, 2009, Wormbo and GreatEmerald
******************************************************************************/

class UT3Paladin extends ONSShockTank;


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     WheelInertia=0.750000
     ChassisTorqueScale=0.100000
     MaxSteerAngleCurve=(Points=((OutVal=20.000000),(InVal=700.000000,OutVal=15.000000)))
     MaxBrakeTorque=75.000000
     SteerSpeed=90.000000
     DriverWeapons(0)=(WeaponClass=Class'UT3Style.UT3PaladinCannon')
     VehicleNameString="UT3 Paladin"
     GroundSpeed=1000.000000
}

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
	VehicleNameString = "UT3 Paladin" //GE: UT3 Paladin...
	SteerSpeed=90                     //Is steered more easily
	ChassisTorqueScale=0.1            //Has a lower... setting of some kind
	MaxBrakeTorque=75.000000          //And another, but this time higher
	MaxSteerAngleCurve=(Points=((OutVal=20.000000),(InVal=700.000000,OutVal=15.000000)))//Again steered more easily
	//EngineBrakeFactor=0.100000       //This makes it extremely easy to flip and have an accident
	WheelInertia=0.750000             //Has more inertia
	GroundSpeed=1000.000000           //Is faster, GroundSpeed == deprecated?
	DriverWeapons(0)=(WeaponClass=class'UT3PaladinCannon',WeaponBone=CannonAttach);//Has a better shield
}

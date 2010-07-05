/******************************************************************************
UT3Raptor

Creation date: 2008-05-02 20:34
Last change: Alpha 2
Copyright (c) 2008 and 2009, Wormbo and GreatEmerald
******************************************************************************/

class UT3Raptor extends ONSAttackCraft;


//=============================================================================
// Default values
//=============================================================================

/*
GE: Test log
Testing values from UT3 code without changes ;)
Test 1: Woah! The Raptor flies looking downwards and spinning like crazy!
Test 2: Commented out all the Damping values. It's now good, but sinks!
Test 3: Sinks because of a huge MaxRiseForce. 500 is unacceptable. The Raptor is too agile now! Let's try splitting in two.
Test 4: 275 works well, although it still gives slight sinkness. But that's OK.
*/

defaultproperties
{
     DriverWeapons(0)=(WeaponClass=Class'UT3Style.UT3RaptorWeapon')
     IdleSound=Sound'UT3Vehicles.RAPTOR.RaptorEngine'
     StartUpSound=Sound'UT3Vehicles.RAPTOR.RaptorTakeOff'
     ShutDownSound=Sound'UT3Vehicles.RAPTOR.RaptorLand'
     VehicleNameString="UT3 Raptor"
     GroundSpeed=2500.000000
}

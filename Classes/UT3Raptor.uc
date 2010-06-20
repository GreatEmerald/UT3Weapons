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
	VehicleNameString = "UT3 Raptor"

	DriverWeapons[0] = (WeaponClass=class'UT3RaptorWeapon',WeaponBone=PlasmaGunAttachment)

    //SCREW THOSE UT3 CODE OPTIONS, THEY'RE ALL FAKE!!!
    /*UprightStiffness=400.000000 //GE: Decreased by 100, whatever that does
	//UprightDamping=20.000000    //Decreased from 300, but according to the manual this has no effect
	MaxThrustForce=750.000000   //Increased a lot. Might give strange side effects!
	//LongDamping=0.700000        //Increased a lot. Might give strange side effects!
	MaxStrafeForce=450.000000   //Increased a lot. Might give strange side effects!
    //LatDamping=0.700000         //Increased a lot. Might give strange side effects!
    //MaxRiseForce=500.000000     //Increased a lot. Might give strange side effects!
    //UpDamping=0.700000          //Increased a lot. Might give strange side effects!
    TurnTorqueFactor=8000.000000//Increased a lot. Might give strange side effects!
    TurnTorqueMax=10000.000000  //Increased a lot. Might give strange side effects!
    //TurnDamping=1.200000        //Decreased a lot. Might give strange side effects!
    PitchTorqueFactor=450.000000//Increased a lot. Might give strange side effects!
    PitchTorqueMax=60.000000    //Increased a lot. Might give strange side effects!
    //PitchDamping=0.300000       //Decreased a lot. Might give strange side effects!
    //RollDamping=0.100000        //Decreased a lot. Might give strange side effects!
    MaxRandForce=25.000000      //Increased a lot. Might give strange side effects!
    RandForceInterval=0.500000  //Somewhat decreased
    */
   	/*UprightStiffness=450.000000 //GE: Decreased
	UprightDamping=160.000000    //Decreased from 300, but according to the manual this has no effect
	MaxThrustForce=200.000000   //Increased. Increased all below too.
	//LongDamping=0.375000
	MaxStrafeForce=265.000000
    //LatDamping=0.375000
    MaxRiseForce=275.000000
    //UpDamping=0.375000
    TurnTorqueFactor=4300.000000
    TurnTorqueMax=5100.000000
    //TurnDamping=25.600000        //Decreased here.
    PitchTorqueFactor=325.000000
    PitchTorqueMax=47.500000
    //PitchDamping=10.150000       //Decreased here.
    //RollDamping=15.050000        //Decreased here.
    MaxRandForce=14.000000
    RandForceInterval=0.625000  Somewhat decreased */
    GroundSpeed=2500            //We are faster now! This should be a true option.
    IdleSound=sound'UT3Vehicles.RAPTOR.RaptorEngine'
    StartUpSound=sound'UT3Vehicles.RAPTOR.RaptorTakeOff'
    ShutDownSound=sound'UT3Vehicles.RAPTOR.RaptorLand'
}

/******************************************************************************
UT3Goliath

Creation date: 2008-05-02 20:50
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3Goliath extends ONSHoverTank;


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     MaxGroundSpeed=600.000000
     MaxThrust=200.000000
     DriverWeapons(0)=(WeaponClass=Class'UT3Style.UT3GoliathCannon')
     PassengerWeapons(0)=(WeaponPawnClass=Class'UT3Style.UT3GoliathTurretPawn')
     IdleSound=Sound'UT3Vehicles.Goliath.GoliathEngine'
     StartUpSound=Sound'UT3Vehicles.Goliath.GoliathStart'
     ShutDownSound=Sound'UT3Vehicles.Goliath.GoliathStop'
     VehicleNameString="UT3 Goliath"
     GroundSpeed=500.000000
     SoundVolume=255
}

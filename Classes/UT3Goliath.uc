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
	VehicleNameString = "UT3 Goliath"
	DriverWeapons(0)=(WeaponClass=class'UT3GoliathCannon',WeaponBone=TankCannonWeapon)
    PassengerWeapons(0)=(WeaponPawnClass=class'UT3GoliathTurretPawn',WeaponBone=MachineGunTurret)
    IdleSound=sound'UT3Vehicles.Goliath.GoliathEngine'
    StartUpSound=sound'UT3Vehicles.Goliath.GoliathStart'
    ShutDownSound=sound'UT3Vehicles.Goliath.GoliathStop'
    MaxGroundSpeed=600.0
    GroundSpeed=500
    SoundVolume=255
    MaxThrust=200.000000//GE: was 65, maybe the tank is too fast now?
}

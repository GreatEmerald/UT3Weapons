/******************************************************************************
UT3PowerupCharger

Creation date: 2008-07-25 16:30
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3PowerupCharger extends UDamageCharger abstract;


//=============================================================================
// Default values
//=============================================================================

//var UT3PickupBasePulseHandler PulseHandler;


//=============================================================================
// Default values
//=============================================================================

/*replication
{
	reliable if (bNetInitial)
		PulseHandler;
}*/


function PostBeginPlay()
{
	Super(xPickupBase).PostBeginPlay();
//	PulseHandler = Spawn(class'UT3PickupBasePulseHandler');
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	bStaticLighting    = True
	bShadowCast        = True
	bAcceptsProjectors = True

	RemoteRole = ROLE_DumbProxy
}

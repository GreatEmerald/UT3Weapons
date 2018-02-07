/******************************************************************************
UT3TranslocatorDisk

Creation date: 2008-07-14 15:09
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3TranslocatorDisk extends TransBeacon abstract;

#exec obj load file=UT3A_Weapon_Translocator.uax

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	Speed = 1330.0
	ImpactSound=Sound'UT3A_Weapon_Translocator.Bounce.BounceCue'
        TransientSoundVolume=1.4
        TransientSoundRadius=15.0
        
}

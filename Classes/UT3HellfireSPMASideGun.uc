/******************************************************************************
UT3HellfireSPMASideGun

Creation date: 2009-02-09 16:10
Latest change: $Id$
Copyright (c) 2009, Wormbo
******************************************************************************/

class UT3HellfireSPMASideGun extends ONSArtillerySideGun;


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	FireSoundClass    = Sound'HellbenderFire'
	AltFireSoundClass = Sound'HellbenderAltFire'
	ProjectileClass   = class'UT3HellfireSPMAShockBall'
}

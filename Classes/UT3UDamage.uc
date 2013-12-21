/******************************************************************************
UT3UDamage

Creation date: 2008-07-20 11:10
Last change: $Id$
Copyright (c) 2008, 2013 Wormbo, GreatEmerald
******************************************************************************/

class UT3UDamage extends UT3TimedPowerup;


//=============================================================================
// Imports
//=============================================================================


//=============================================================================
// Properties
//=============================================================================

var Sound UDamageFireSound;


simulated function PostNetBeginPlay()
{
	if (xPawn(Instigator) != None)
		xPawn(Instigator).UDamageSound = UDamageFireSound;
}

function EnableEffect()
{
	Instigator.EnableUDamage(LifeSpan);
	if (xPawn(Instigator) != None) {
		xPawn(Instigator).UDamageSound = UDamageFireSound;
		if (xPawn(Instigator).UDamageTimer != None)
			xPawn(Instigator).UDamageTimer.Destroy();
	}
}


function UpdateEffect()
{
	Instigator.EnableUDamage(LifeSpan);
	if (xPawn(Instigator) != None && xPawn(Instigator).UDamageTimer != None)
		xPawn(Instigator).UDamageTimer.Destroy();
}


function DisableEffect()
{
	Instigator.DisableUDamage();
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	// HACK: online UDamage fire sound change
	bAlwaysRelevant = True
	bOnlyRelevantToOwner = False
	bReplicateInstigator = True

	PickupClass = class'UT3UDamagePickup'

	UDamageFireSound = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_Fire'
	PowerAmbientSound = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_PowerLoop'
	WarningSound = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_Warning'
	EndSound = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_End'
}

/******************************************************************************
UT3UDamage

Creation date: 2008-07-20 11:10
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3UDamage extends UT3TimedPowerup;


//=============================================================================
// Imports
//=============================================================================

#exec audio import group=UDamage file=Sounds\include\UDamage\UDamagePowerLoop.wav
#exec audio import group=UDamage file=Sounds\include\UDamage\UDamageFire.wav
#exec audio import group=UDamage file=Sounds\include\UDamage\UDamageWarning.wav
#exec audio import group=UDamage file=Sounds\include\UDamage\UDamageEnd.wav


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
	
	UDamageFireSound = Sound'UDamageFire'
	PowerAmbientSound = Sound'UDamagePowerLoop'
	WarningSound = Sound'UDamageWarning'
	EndSound = Sound'UDamageEnd'
}

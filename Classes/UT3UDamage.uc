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

#exec audio import group=UDamage file=Sounds\UDamage\UDamagePowerLoop.wav
#exec audio import group=UDamage file=Sounds\UDamage\UDamageFire.wav
#exec audio import group=UDamage file=Sounds\UDamage\UDamageWarning.wav
#exec audio import group=UDamage file=Sounds\UDamage\UDamageEnd.wav


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
     UDamageFireSound=Sound'UT3Style.Udamage.UDamageFire'
     PowerAmbientSound=Sound'UT3Style.Udamage.UDamagePowerLoop'
     WarningSound=Sound'UT3Style.Udamage.UDamageWarning'
     EndSound=Sound'UT3Style.Udamage.UDamageEnd'
     PickupClass=Class'UT3Style.UT3UDamagePickup'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}

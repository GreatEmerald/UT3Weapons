/******************************************************************************
UT3TimedPowerup

Creation date: 2008-07-20 11:09
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3TimedPowerup extends UT3Powerup abstract;


//=============================================================================
// Properties
//=============================================================================

var int NumWarningSounds;
var float WarningInterval;
var Sound PowerAmbientSound;
var Sound WarningSound;
var Sound EndSound;


//=============================================================================
// Variables
//=============================================================================

var AimedAttachment AttachedAmbientSound;


function PickupFunction(Pawn Other)
{
	if (WarningSound != None) {
		if (LifeSpan > NumWarningSounds * WarningInterval) {
			SetTimer(LifeSpan - NumWarningSounds * WarningInterval + 0.01, False);
		} else {
			SetTimer(LifeSpan - LifeSpan % WarningInterval + 0.01, False);
		}
	}
	if (PowerAmbientSound != None) {
		AttachedAmbientSound = Spawn(class'AimedAttachment', Other,, Other.Location, Other.Rotation);
		AttachedAmbientSound.bHidden = True;
		AttachedAmbientSound.AmbientSound = PowerAmbientSound;
		AttachedAmbientSound.SoundRadius = SoundRadius;
		AttachedAmbientSound.SoundVolume = SoundVolume;
		AttachedAmbientSound.SoundPitch = SoundPitch;
		AttachedAmbientSound.SetBase(Other);
	}
	EnableEffect();
}

/**
Timed powerups add the remaining time of the same type pickup to
their own remaining time.
*/
function bool HandlePickupQuery(Pickup Item)
{
	if (Item.InventoryType == Class && UT3TimedPickup(Item) != None) {
		LifeSpan += UT3TimedPickup(Item).TimeRemaining;
		Item.TriggerEvent(Item.Event, Item, Instigator);
		Item.AnnouncePickup(Instigator);
		Item.SetRespawn();
		UpdateEffect();
		return true;
	}
	return Super.HandlePickupQuery(Item);
}


function Destroyed()
{
	if (AttachedAmbientSound != None) {
		AttachedAmbientSound.Destroy();
	}
	if (Instigator != None) {
		if (LifeSpan > 0.0001) {
			// TODO: drop pickup
		} else {
			if (EndSound != None)
				Owner.PlaySound(EndSound,, TransientSoundVolume,, TransientSoundRadius);
		}
		DisableEffect();
	}
	Super.Destroyed();
}


function EnableEffect();
function UpdateEffect();
function DisableEffect();


function Timer()
{
	if (LifeSpan > NumWarningSounds * WarningInterval) {
		// time was added
		SetTimer(LifeSpan - NumWarningSounds * WarningInterval + 0.01, False);
	} else {
		SetTimer(WarningInterval, False);
		Owner.PlaySound(WarningSound,, TransientSoundVolume,, TransientSoundRadius);
	}
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	NumWarningSounds = 4
	WarningInterval = 0.75
	LifeSpan = 30.0
	SoundVolume = 255
	SoundRadius = 1000.0
	TransientSoundVolume = 1.0
	TransientSoundRadius = 1000.0
}

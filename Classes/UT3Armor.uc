/******************************************************************************
UT3Armor

Creation date: 2008-07-15 11:21
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3Armor extends Armor abstract;


simulated function BeginPlay()
{
	Super(UT3Powerup).BeginPlay();
}


function ArmorImpactEffect(vector HitLocation)
{
	if (xPawn(Owner) != None) {
		Owner.SetOverlayMaterial(xPawn(Owner).ShieldHitMat, xPawn(Owner).ShieldHitMatTime, false);
		Owner.PlaySound(Sound'WeaponSounds.ArmorHit', SLOT_Pain, 2 * Owner.TransientSoundVolume,, 400);
	}
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
}

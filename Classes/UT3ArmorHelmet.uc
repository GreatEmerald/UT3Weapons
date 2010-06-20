/******************************************************************************
UT3ArmorHelmet

Creation date: 2008-07-15 11:40
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3ArmorHelmet extends UT3Armor;


/**
Highest priority for headshots.
*/
function int ArmorPriority(class<DamageType> DamageType)
{
	if (DamageType.default.bArmorStops && DamageType.default.bAlwaysSevers && DamageType.default.bSpecial)
		return 1000000;

	return Super.ArmorPriority(DamageType);
}


/**
Completely absorb one headshot.
*/
function int ArmorAbsorbDamage(int Damage, class<DamageType> DamageType, vector HitLocation)
{
	if (DamageType.default.bArmorStops && DamageType.default.bAlwaysSevers && DamageType.default.bSpecial) {
		ArmorImpactEffect(HitLocation);
		Destroy();
		return 0;
	}
	
	return Super.ArmorAbsorbDamage(Damage, DamageType, HitLocation);
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	//PickupClass = class'UT3ArmorHelmetPickup'
	Charge=20
	ArmorAbsorption=50
	AbsorptionPriority=20
}

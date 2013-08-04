/******************************************************************************
MutUT3Weapons

Creation date: 2008-07-14 12:27
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class MutUT3Weapons extends Mutator;


/**
Modifies pickup bases to spawn the corresponding UT3-style pickups.
*/
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local int i;
	local class<Pickup> NewPickupClass;
	local class<Weapon> NewWeaponClass;
	local WeaponLocker Locker;

	if (xWeaponBase(Other) != None) {
		NewWeaponClass = GetReplacementWeapon(xWeaponBase(Other).WeaponType);
		if (NewWeaponClass != None)
			xWeaponBase(Other).WeaponType = NewWeaponClass;
	}
	else if (WildcardBase(Other) != None) {
		// TODO: replace individual powerups
	}
	else if (xPickupBase(Other) != None) {
		NewPickupClass = GetReplacementPickup(xPickupBase(Other).Powerup);
		if (NewPickupClass != None)
			xPickupBase(Other).Powerup = NewPickupClass;
	}
	else if (WeaponLocker(Other) != None) {
		Locker = WeaponLocker(Other);

		for (i = 0; i < Locker.Weapons.Length; ++i) {
			NewWeaponClass = GetReplacementWeapon(Locker.Weapons[i].WeaponClass);
			if (NewWeaponClass != None)
				Locker.Weapons[i].WeaponClass = NewWeaponClass;
		}
	}
	else if (Pickup(Other) != None && Pickup(Other).MyMarker != None) {
		NewPickupClass = GetReplacementPickup(Pickup(Other).Class);
		if (NewPickupClass != None && ReplaceWith(Other, string(NewPickupClass))) {
			return false;
		}
	}
	return Super.CheckReplacement(Other, bSuperRelevant);
}


function string GetInventoryClassOverride(string InventoryClassName)
{
	local class<Weapon> NewWeaponClass;

	NewWeaponClass = GetReplacementWeapon(InventoryClassName);
	if (NewWeaponClass != None) {
		return string(NewWeaponClass);
	}
	return Super.GetInventoryClassOverride(InventoryClassName);
}


function class<Weapon> GetReplacementWeapon(coerce string Original)
{
	if (Right(Original, 6) ~= "Pickup")
		Original = Left(Original, Len(Original) - 6);
	switch (Locs(Original)) {
	case "xweapons.translauncher":
		return class'UT3Translocator';
	case "xweapons.shieldgun":
		return class'UT3ImpactHammer';
	case "xweapons.linkgun":
		return class'UT3LinkGun';
	case "xweapons.flakcannon":
		return class'UT3FlakCannon';
	case "xweapons.assaultrifle":
		return class'UT3Enforcer';
	case "xweapons.shockrifle":
		return class'UT3ShockRifle';
	case "xweapons.minigun":
		return class'UT3Minigun2v';
	case "xweapons.biorifle":
		return class'UT3BioRifle';
	case "xweapons.sniperrifle":
	case "utclassic.classicsniperrifle":
		return class'UT3SniperRifle';
	case "xweapons.rocketlauncher":
		return class'UT3RocketLauncher';
	case "onslaught.onsavril":
		return class'UT3AVRIL';

	case "xweapons.redeemer":
		return class'UT3Redeemer';
	case "xweapons.supershockrifle":
	    return class'UT3InstagibRifle';
    default: return none;
	}
}


function class<Pickup> GetReplacementPickup(class<Pickup> Original)
{
	switch (Original) {
	case class'MiniHealthPack':
		return class'UT3HealthPickupSmall';
	case class'HealthPack':
		return class'UT3HealthPickupMedium';
	case class'SuperHealthPack':
		return class'UT3HealthPickupSuper';
	case class'ShieldPack':
		return class'UT3ArmorVestPickup';
	case class'SuperShieldPack':
		return class'UT3ArmorShieldbeltPickup';
	case class'UDamagePack':
		return class'UT3UDamagePickup';
	case class'LinkAmmoPickup':
	    return class'UT3LinkAmmoPickup';
    case class'FlakAmmoPickup':
	    return class'UT3FlakAmmoPickup';
    case class'ShockAmmoPickup':
	    return class'UT3ShockAmmoPickup';
    case class'MinigunAmmoPickup':
	    return class'UT3MinigunAmmoPickup';
    case class'SniperAmmoPickup':
    case class'UTClassic.ClassicSniperAmmoPickup':
	    return class'UT3SniperAmmoPickup';
    case class'RocketAmmoPickup':
	    return class'UT3RocketAmmoPickup';
    case class'BioAmmoPickup':
	    return class'UT3BioAmmoPickup';
    case class'ONSAVRiLAmmoPickup':
	    return class'UT3AVRiLAmmoPickup';
    case class'AssaultAmmoPickup':
	    return class'UT3EnforcerAmmoPickup';
    default: return none;
	}
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    FriendlyName = "UT3 Weapons"
    Description  = "Modifies UT2004 weapons so they work similarly to their UT3 counterparts."
    GroupName    = "Arena"
    bAddToServerPackages = true
}

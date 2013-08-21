/******************************************************************************
MutUT3Weapons

Creation date: 2008-07-14 12:27
Last change: $Id$
Copyright (c) 2008, 2013 Wormbo, GreatEmerald
******************************************************************************/

class MutUT3Weapons extends Mutator;

#exec obj load file=UT3PICKUPS_Mesh.usx

/**
Modifies pickup bases to spawn the corresponding UT3-style pickups.
*/
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    local int i;
    local class<Pickup> NewPickupClass;
    local class<Weapon> NewWeaponClass;
    local class<UT3PickupFactory> NewFactoryClass;
    local WeaponLocker Locker;
    local bool bOriginalCollision;
    local bool bResult;

    if (xWeaponBase(Other) != None)
    {
        NewWeaponClass = GetReplacementWeapon(xWeaponBase(Other).WeaponType);
        if (NewWeaponClass != None)
            xWeaponBase(Other).WeaponType = NewWeaponClass;
        // GEm: TODO: Disable bases, spawn our own on top, otherwise it doesn't scale and has net issues
        xWeaponBase(Other).SetStaticMesh(StaticMesh'UT3PICKUPS_Mesh.WeaponBase.S_Pickups_WeaponBase');
        xWeaponBase(Other).NewDrawScale = 1.0;
        xWeaponBase(Other).NewPrePivot = vect(0.0, 0.0, 0.0);
        xWeaponBase(Other).SetDrawScale(1.0);
        xWeaponBase(Other).PrePivot = vect(0.0, 0.0, 0.0);
    }
	else if (WildcardBase(Other) != None) {
		// TODO: replace individual powerups
	}
    else if (xPickUpBase(Other) != None)
    {
        NewFactoryClass = GetReplacementFactory(xPickUpBase(Other).class);
        if (NewFactoryClass != None)
        {
            Other.bHidden = true;
            xPickUpBase(Other).PowerUp = None;
            if (xPickUpBase(Other).myEmitter != None)
                xPickUpBase(Other).myEmitter.Destroy();
            if (xPickUpBase(Other).myPickUp != None)
                xPickUpBase(Other).myPickUp.Destroy();

            if (ReplaceWith(Other, string(NewFactoryClass)))
                return true;
        }

        // GEm: Legacy code follows
        NewPickupClass = GetReplacementPickup(xPickUpBase(Other).Powerup);
        if (NewPickupClass != None)
        {
            xPickupBase(Other).Powerup = NewPickupClass;
        }
        // GEm: Temporary hacks below!
        if (ShieldCharger(Other) != None || SuperShieldCharger(Other) != None)
        {
            xPickupBase(Other).SetStaticMesh(StaticMesh'UT3PICKUPS_Mesh.Base_Armor.S_Pickups_Base_Armor');
        }
        else if (UDamageCharger(Other) != None || WildcardBase(Other) != None)
        {
            xPickupBase(Other).SetStaticMesh(StaticMesh'UT3PICKUPS_Mesh.Base_Powerup.S_Pickups_Base_Powerup01');
        }
        if (HealthCharger(Other) != None || SuperHealthCharger(Other) != None
            || ShieldCharger(Other) != None || SuperShieldCharger(Other) != None
            || UDamageCharger(Other) != None || WildcardBase(Other) != None)
        {
            xPickupBase(Other).NewDrawScale = 1.0;
            xPickupBase(Other).NewPrePivot = vect(0.0, 0.0, 0.0);
            xPickupBase(Other).SetDrawScale(1.0);
            xPickupBase(Other).PrePivot = vect(0.0, 0.0, 0.0);
        }
    }
	else if (WeaponLocker(Other) != None) {
		Locker = WeaponLocker(Other);

		for (i = 0; i < Locker.Weapons.Length; ++i) {
			NewWeaponClass = GetReplacementWeapon(Locker.Weapons[i].WeaponClass);
			if (NewWeaponClass != None)
				Locker.Weapons[i].WeaponClass = NewWeaponClass;
		}
	}
    else if (Pickup(Other) != None && Pickup(Other).MyMarker != None)
    {
        NewPickupClass = GetReplacementPickup(Pickup(Other).Class);
        if (NewPickupClass != None)
        {
            // GEm: Temporarily disable collision so we could spawn near walls
            //bOriginalCollision = NewPickupClass.default.bCollideWorld;
            //NewPickupClass.default.bCollideWorld = false;
            bResult = ReplaceWith(Other, string(NewPickupClass));
            //NewPickupClass.default.bCollideWorld = bOriginalCollision;
            if (bResult)
                return false;
        }
        log("MutUT3Weapons: CheckReplacement: Not replacing"@Other);
    }
	return Super.CheckReplacement(Other, bSuperRelevant);
}

// GEm: Override so all the new pickups could spawn correctly
function bool ReplaceWith(actor Other, string aClassName)
{
    local Actor A;
    local class<Actor> aClass;
    local bool bOldCollideWorld;

    if ( aClassName == "" )
        return true;

    aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
    if ( aClass == None )
        return false;

    if ( Other.IsA('Pickup') )
    {
        bOldCollideWorld = Other.default.bCollideWorld;
        aClass.default.bCollideWorld = false;

        A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);

        A.bCollideWorld = bOldCollideWorld;
        aClass.default.bCollideWorld = bOldCollideWorld;

        if ( Pickup(Other).MyMarker != None )
        {
            Pickup(Other).MyMarker.markedItem = Pickup(A);
            if ( Pickup(A) != None )
            {
                Pickup(A).MyMarker = Pickup(Other).MyMarker;
                A.SetLocation(A.Location
                    + (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
                A.SetBase(Other.Base);
            }
            Pickup(Other).MyMarker = None;
        }
        else if ( A.IsA('Pickup') )
            Pickup(A).Respawntime = 0.0;
    }
    else
        A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);

    if ( A != None )
    {
        A.event = Other.event;
        A.tag = Other.tag;
        return true;
    }
    return false;
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

function class<UT3PickupFactory> GetReplacementFactory(class<xPickUpBase> Original)
{
    switch (Original)
    {
        case class'HealthCharger':
        case class'NewHealthCharger':
            return class'UT3PickupFactory_MediumHealth';
        case class'SuperHealthCharger':
        case class'NewSuperHealthCharger':
            return class'UT3PickupFactory_SuperHealth';
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

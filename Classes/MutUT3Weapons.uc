/******************************************************************************
MutUT3Weapons

Creation date: 2008-07-14 12:27
Last change: $Id$
Copyright (c) 2008, 2013, 2014 Wormbo, GreatEmerald
******************************************************************************/

class MutUT3Weapons extends Mutator;

#exec obj load file=UT3PICKUPS_Mesh.usx

// GEm: This is not in CheckReplacement for replication purposes
simulated function BeginPlay()
{
    local xPickUpBase P;
    local Pickup L;

    foreach AllActors(class'xPickUpBase', P)
    {
        if (UT3PickupFactory(P) != None)
            continue;
        P.bHidden = true;
        if (P.myEmitter != None)
            P.myEmitter.Destroy();
        P.ResetStaticFilterState();
    }

    foreach AllActors(class'Pickup', L)
        if ( L.IsA('WeaponLocker') )
            L.GotoState('Disabled');

    Super.BeginPlay();
}

/**
GEm: Modifies pickup bases to spawn the corresponding UT3-style pickups.
     Note that CheckReplacement gets called early at spawn, before Pickups'
     PickUpBase is even set; and that when pickup bases are iterated, they don't
     yet have their pickups spawned.
*/
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    local class<Pickup> NewPickupClass;
    local class<UT3PickupFactory> NewFactoryClass;
    local bool bResult;

    if (xPickUpBase(Other) != None)
    {
        NewFactoryClass = GetReplacementFactory(xPickUpBase(Other).class);
        if (NewFactoryClass != None)
        {
            bResult = ReplaceWith(Other, string(NewFactoryClass));

            xPickUpBase(Other).PowerUp = None;
            /*if (xPickUpBase(Other).myPickUp != None)
            {
                if (xPickUpBase(Other).bStatic || xPickUpBase(Other).bNoDelete)
                    xPickUpBase(Other).GotoState('Disabled');
                else
                    xPickUpBase(Other).myPickUp.Destroy();
            }*/

            if (bResult)
                return true;
        }

        // GEm: For unknown pickup bases, hopefully this never happens
        NewPickupClass = GetReplacementPickup(xPickUpBase(Other).Powerup);
        if (NewPickupClass != None)
            xPickupBase(Other).Powerup = NewPickupClass;
    }
    // GEm: We disable stock lockers and spawn our own
    else if (WeaponLocker(Other) != None && UT3WeaponLocker(Other) == None)
    {
        ReplaceWith(Other, string(class'UT3WeaponLocker'));
    }
    else if (Pickup(Other) != None && Pickup(Other).bDeleteMe == false)
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
        else
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
    local class<Weapon> NewWeaponClass;
    local class<TournamentPickup> NewPickupClass;
    local int i;

    if ( aClassName == "" )
        return true;

    aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
    if ( aClass == None )
        return false;

    if ( Other.IsA('Pickup') )
    {
        bOldCollideWorld = Other.default.bCollideWorld;
        aClass.default.bCollideWorld = false;

        if (WeaponLocker(Other) != None)
            A = Spawn(aClass, Other, Other.tag, Other.Location, Other.Rotation);
        else
            A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);

        A.bCollideWorld = bOldCollideWorld;
        aClass.default.bCollideWorld = bOldCollideWorld;

        if ( Pickup(Other).MyMarker != None )
        {
            Pickup(Other).MyMarker.markedItem = Pickup(A);
            if ( Pickup(A) != None )
            {
                Pickup(A).MyMarker = Pickup(Other).MyMarker;
                if (UT3WeaponLocker(A) == None)
                {
                    A.SetLocation(A.Location
                        + (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
                    A.SetBase(Other.Base);
                }
            }
            Pickup(Other).MyMarker = None;
        }
        else if ( A.IsA('Pickup') ){log(self@"ReplaceWith: RespawnTime disabled for"@A);
            Pickup(A).Respawntime = 0.0;}
        if (A.IsInState('Disabled') || A.IsInState('Sleeping'))
            A.GotoState(Other.GetStateName());
    }
    else if (xPickUpBase(Other) != None)
    {
        A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);

        if (WildcardBase(Other) != None && UT3WildcardFactory(A) != None)
        {
            for (i=0; i<ArrayCount(WildcardBase(Other).PickupClasses); i++)
            {
                NewPickupClass = class<TournamentPickup>(GetReplacementPickup(WildcardBase(Other).PickupClasses[i]));
                if (NewPickupClass != None)
                    UT3WildcardFactory(A).PickupClasses[i] = NewPickupClass;
                WildcardBase(Other).PickupClasses[i] = None; // GEm: Disable the original
            }
            UT3WildcardFactory(A).bSequential = WildcardBase(Other).bSequential;
        }

        if (xPickUpBase(A) != None)
        {
            xPickUpBase(A).PowerUp = GetReplacementPickup(xPickUpBase(Other).PowerUp);
            if (UT3PickupFactory(A) != None)
                UT3PickupFactory(A).SpawnPickup();
        }

        if (xWeaponBase(Other) != None && UT3WeaponPickupFactory(A) != None)
        {
            NewWeaponClass = GetReplacementWeapon(xWeaponBase(Other).WeaponType);
            if (NewWeaponClass != None)
                UT3WeaponPickupFactory(A).WeaponType = NewWeaponClass;
            else
                UT3WeaponPickupFactory(A).WeaponType = xWeaponBase(Other).WeaponType;
            UT3WeaponPickupFactory(A).WeaponChanged();
            xWeaponBase(Other).WeaponType = None;
        }
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


static function class<Weapon> GetReplacementWeapon(coerce string Original)
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


static function class<Pickup> GetReplacementPickup(class<Pickup> Original)
{
    switch (Original)
    {
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
        default: return None;
    }
}

static function class<UT3PickupFactory> GetReplacementFactory(class<xPickUpBase> Original)
{
    switch (Original)
    {
        case class'HealthCharger':
        case class'NewHealthCharger':
            return class'UT3PickupFactory_MediumHealth';
        case class'SuperHealthCharger':
        case class'NewSuperHealthCharger':
            return class'UT3PickupFactory_SuperHealth';
        case class'ShieldCharger':
            return class'UT3ArmorFactory_Wildcard';
        case class'SuperShieldCharger':
            return class'UT3ArmorFactory_ShieldBelt';
        case class'UDamageCharger':
            return class'UT3PickupFactory_UDamage';
        case class'xWeaponBase':
        case class'NewWeaponBase':
            return class'UT3WeaponPickupFactory';
        case class'WildcardBase':
            return class'UT3WildcardFactory';
        default: return none;
    }
}

// GEm: Debug
/*function PostBeginPlay()
{
    Super.PostBeginPlay();

    log(self@"PostBeginPlay: Start precached material listings.");
    UpdatePrecacheMaterials();
    UpdatePrecacheStaticMeshes();

}

function UpdatePrecacheMaterials()
{
    local int i;

    Super.UpdatePrecacheMaterials();
    log(self@"UpdatePrecacheMaterials: Precached material listing:");
    for (i=0; i<Level.PrecacheMaterials.length; i++)
        log(Level.PrecacheMaterials[i]);
    log(self@"UpdatePrecacheMaterials: End of listing.");
}

function UpdatePrecacheStaticMeshes()
{
    local int i;

    Super.UpdatePrecacheStaticMeshes();
    log(self@"UpdatePrecacheStaticMeshes: Precached static mesh listing:");
    for (i=0; i<Level.PrecacheStaticMeshes.length; i++)
        log(Level.PrecacheStaticMeshes[i]);
    log(self@"UpdatePrecacheStaticMeshes: End of listing.");
}*/

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    FriendlyName = "UT3 Weapons"
    Description  = "Modifies UT2004 weapons so they work similarly to their UT3 counterparts."
    GroupName    = "Arena"
    bAddToServerPackages = true
    bAlwaysRelevant = true
    RemoteRole   = ROLE_SimulatedProxy
    bNetTemporary = true
}

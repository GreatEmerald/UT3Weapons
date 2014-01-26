//=============================================================================
// UT3WeaponLocker.uc
// Modern weapon locker done better
// Copyright © 2014 GreatEmerald
//=============================================================================

class UT3WeaponLocker extends WeaponLocker;

var UT3DecorativeMesh PickupMeshes[6];

var WeaponLocker LockerToCopy;
var bool bUT3MutatorActive;

replication
{
    unreliable if (Role == ROLE_Authority) // GEm: Send from server to client
        LockerToCopy, bUT3MutatorActive;
}

// GEm: Make the respawn time customisable
function bool AddCustomer(Pawn P)
{
    local int                       i;
    local PawnToucher       PT;

    if ( Customers.Length > 0 )
        for ( i=0; i<Customers.Length; i++ )
        {
            if ( Customers[i].NextTouchTime < Level.TimeSeconds )
            {
                if ( Customers[i].P == P )
                {
                    Customers[i].NextTouchTime = Level.TimeSeconds + RespawnTime;
                    return true;
                }
                Customers.Remove(i,1);
                i--;
            }
            else if ( Customers[i].P == P )
                return false;
        }

    PT.P = P;
    PT.NextTouchTime = Level.TimeSeconds + RespawnTime;
    Customers[Customers.Length] = PT;
    return true;
}

simulated function PreBeginPlay()
{
    local Mutator M;

    if (Level.Game != None) // GEm: Only on servers
    {
        for (M = Level.Game.BaseMutator; M != None; M = M.NextMutator)
            if (MutUT3Weapons(M) != None)
                bUT3MutatorActive = true;
    }
    if (WeaponLocker(Owner) != None)
        LockerToCopy = WeaponLocker(Owner);
    if (LockerToCopy != None)
        CopyLocker(LockerToCopy);

    Super.PreBeginPlay();
}

simulated function PostNetBeginPlay()
{
    local int i;

    Super(Pickup).PostNetBeginPlay();

    MaxDesireability = 0;

    if ( bHidden )
        return;
    for ( i=0; i<Weapons.Length; i++ )
        MaxDesireability += Weapons[i].WeaponClass.Default.AIRating;
    SpawnLockerWeapon();

    // GEm: TODO: Replace with UT3 particles
    /*if ( Level.NetMode != NM_DedicatedServer )
        Effect = Spawn(class'FX_WeaponLocker', Self,, Location, Rotation );*/
}

simulated function PostNetReceive()
{
    if (LockerToCopy != None)
    {
        CopyLocker(LockerToCopy);
        //PostNetBeginPlay();
    }
}

simulated function CopyLocker(WeaponLocker Original)
{
    local int i;
    //local MutUT3Weapons UT3Mut;
    //local Mutator M;
    local class<Weapon> NewWeaponClass;
    local array<WeaponEntry> NewWeapons;

    bSentinelProtected = Original.bSentinelProtected;
    NewWeapons = Original.Weapons;

    /*for (M = Level.Game.BaseMutator; M != None; M = M.NextMutator)
    {
        log(self@"CopyLocker: Searching for mutators...");
        if (MutUT3Weapons(M) != None)
        {
            log(self@"CopyLocker: Found it!");
            UT3Mut = MutUT3Weapons(M);*/

            for (i = 0; i < Original.Weapons.length; i++)
            {
                //NewWeaponClass = UT3Mut.static.GetReplacementWeapon(Original.Weapons[i].WeaponClass);
                if (bUT3MutatorActive)
                    NewWeaponClass = class'MutUT3Weapons'.static.GetReplacementWeapon(Original.Weapons[i].WeaponClass);
                if (NewWeaponClass != None)
                    NewWeapons[i].WeaponClass = NewWeaponClass;
            }
            /*break;
        }
    }*/

    // GEm: Need to put on a different function for replication (clients do not concern themselves with Owner)
    for (i = 0; i < NewWeapons.length; i++)
    {
        CopyWeapon(i, NewWeapons[i].WeaponClass, NewWeapons[i].ExtraAmmo);
    }
}

simulated function CopyWeapon(int Slot, class<Weapon> WeaponClass, int ExtraAmmo)
{
    if (Weapons.length <= Slot)
        Weapons.length = Slot+1;
    Weapons[Slot].WeaponClass = WeaponClass;
    Weapons[Slot].ExtraAmmo = ExtraAmmo;
}

simulated function SpawnLockerWeapon()
{
    local int i, n;
    local class<UTWeaponPickup> P;
    local Rotator WeaponDir, WeaponRot;
    local Vector WeaponLocation;

    if ( (Level.NetMode == NM_DedicatedServer) || (Level.DetailMode == DM_Low) )
        return;

    for (i = 0; i < Weapons.length; i++)
    {
        if (n >= ArrayCount(PickupMeshes))
            break;

        P = class<UTWeaponPickup>(Weapons[i].WeaponClass.default.PickupClass);

        if (P != None && P.default.StaticMesh != None)
        {
            // GEm: Where the mesh is relative to the base
            WeaponDir.Yaw = 65536 * n / ArrayCount(PickupMeshes);
            WeaponLocation = Location + P.default.LockerOffset * Vector(WeaponDir);
            WeaponLocation += PrePivot;
            WeaponLocation.Z -= DrawScale * PrePivot.Z * 0.75;
            // GEm: How the mesh is rotated to look vertical (StandUp is a rotator in disguise)
            WeaponRot.Pitch = P.default.StandUp.Y * 65536;
            WeaponRot.Yaw = P.default.StandUp.X * 65536 + WeaponDir.Yaw - 32768;
            WeaponRot.Roll = P.default.StandUp.Z * 65536;

            PickupMeshes[n] = Spawn(class'UT3DecorativeMesh', self, , WeaponLocation, WeaponRot);
            PickupMeshes[n].SetStaticMesh(P.default.StaticMesh);
            PickupMeshes[n].Skins = P.default.Skins;
            PickupMeshes[n].SetDrawScale(P.default.DrawScale * DrawScale);
            PickupMeshes[n].PrePivot = P.default.PrePivot;
            n++;
        }
    }
}

auto simulated state LockerPickup
{
    // When touched by an actor.
    simulated function Touch( actor Other )
    {
        local Weapon    Copy;
        local int               i;

        // If touched by a player pawn, let him pick this up.
        if( ValidTouch(Other) )
        {
            if ( (PlayerController(Pawn(Other).Controller) != None) && (Viewport(PlayerController(Pawn(Other).Controller).Player) != None) )
            {
                if ( (Level.NetMode != NM_DedicatedServer) && (Level.DetailMode != DM_Low)
                    && IsMeshVisible())
                {
                    if ( (Effect != None) && !Effect.bHidden )
                        Effect.TurnOff(RespawnTime);

                    GoToState(, 'Waiting');
                }
            }
            if ( Role < ROLE_Authority )
                return;
            if ( !AddCustomer(Pawn(Other)) )
                return;
            TriggerEvent(Event, self, Pawn(Other));
            for ( i=0; i<Weapons.Length; i++ )
            {
                InventoryType = Weapons[i].WeaponClass;
                Copy =  Weapon(Pawn(Other).FindInventoryType(Weapons[i].WeaponClass));
                if ( Copy != None )
                    Copy.FillToInitialAmmo();
                else if ( Level.Game.PickupQuery(Pawn(Other), self) )
                {
                    Copy = Weapon(SpawnCopy(Pawn(Other)));
                    if ( Copy != None )
                    {
                        Copy.PickupFunction(Pawn(Other));
                        if ( Weapons[i].ExtraAmmo > 0 )
                            Copy.AddAmmo(Weapons[i].ExtraAmmo, 0);
                    }
                }
            }

            AnnouncePickup( Pawn(Other) );
        }
    }

    simulated function ToggleMeshVisibility()
    {
        local int i;

        for (i = 0; i < ArrayCount(PickupMeshes); i++)
            if (PickupMeshes[i] != None)
                PickupMeshes[i].bHidden = !PickupMeshes[i].bHidden;
    }

    simulated function bool IsMeshVisible()
    {
        local int i;

        for (i = 0; i < ArrayCount(PickupMeshes); i++)
            if (PickupMeshes[i] != None && !PickupMeshes[i].bHidden)
                return true;
        return false;
    }
Waiting:
    ToggleMeshVisibility();
    Sleep(RespawnTime);
    ToggleMeshVisibility();
}

simulated function Destroyed()
{
    local int i;

    for (i = 0; i < ArrayCount(PickupMeshes); i++)
        if (PickupMeshes[i] != None)
            PickupMeshes[i].Destroy();

    Super(Pickup).Destroyed();
}

state Disabled
{
    simulated function BeginState()
    {
        local int i;

        Super(Pickup).BeginState();
        for (i = 0; i < ArrayCount(PickupMeshes); i++)
            if (PickupMeshes[i] != None)
                PickupMeshes[i].Destroy();

    }
}

defaultproperties
{
    bStatic = false
    StaticMesh = StaticMesh'UT3GP_Onslaught_Mesh.Mesh.S_GP_Ons_Weapon_Locker'
    DrawScale = 1.0
    DrawScale3D = (X=1.0,Y=1.0,Z=1.0)
    PrePivot = (X=0.0,Y=0.0,Z=52.5)
    RespawnTime = 30.0
    bShouldBaseAtStartup = false
    RemoteRole = ROLE_SimulatedProxy
    //NetUpdateFrequency = 0.1
    //bOnlyReplicateHidden = false
    bNetNotify = true
}

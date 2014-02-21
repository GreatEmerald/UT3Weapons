//=============================================================================
// UT3WildcardFactory.uc
// A nicer-looking replacement for the Wildcard base
// Copyright © 2014 GreatEmerald
//=============================================================================

class UT3WildcardFactory extends UT3PowerupPickupFactory;

var() class<TournamentPickup> PickupClasses[8];
var() bool bSequential;
var int NumClasses;
var int CurrentClass;

simulated function PostBeginPlay()
{
    InitClasses();
    Super.PostBeginPlay();
    SetLocation(Location + vect(0,0,-1)); // adjust because reduced drawscale
}

simulated function InitClasses()
{
    local int i;

    if ( Role == ROLE_Authority )
    {
        NumClasses = 0;
        while (NumClasses < ArrayCount(PickupClasses) && PickupClasses[NumClasses] != None)
            NumClasses++;

        if (bSequential)
            CurrentClass = 0;
        else
            CurrentClass = Rand(NumClasses);

        PowerUp = PickupClasses[CurrentClass];
    }
    if ( Level.NetMode != NM_DedicatedServer )
    {
        for ( i=0; i< NumClasses; i++ )
            PickupClasses[i].static.StaticPrecache(Level);
    }
    log(self@"InitClasses: PowerUp"@PowerUp);
}

function TurnOn()
{
    if (bSequential)
        CurrentClass = (CurrentClass+1)%NumClasses;
    else
        CurrentClass = Rand(NumClasses);

    PowerUp = PickupClasses[CurrentClass];

    if (myPickup != None && PowerUp != None)
        myPickup = myPickup.Transmogrify(PowerUp);
    log(self@"TurnOn: PowerUp"@PowerUp);
}

function SpawnPickup()
{
    if (PowerUp != PickupClasses[CurrentClass] || CurrentClass > NumClasses)
        InitClasses();
    log(self@"SpawnPickup:"@PowerUp@">"@myPickup@CurrentClass@NumClasses);
    Super.SpawnPickup();
}

defaultproperties
{
    bSequential=false
    CollisionRadius=60.000000
    CollisionHeight=6.000000
    PickupClasses(0)=class'UT3HealthPickupMedium'
    PickupClasses(1)=class'UT3ArmorShieldbeltPickup'
    PickupClasses(2)=class'UT3HealthPickupSuper'
    PickupClasses(3)=class'UT3UDamagePickup'
}

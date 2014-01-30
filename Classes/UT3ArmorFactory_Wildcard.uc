//=============================================================================
// UT3ArmorFactory_Wildcard.uc
// Base that spawns random armour pickups, for replacing shields
// Copyright © 2014 GreatEmerald
//=============================================================================

class UT3ArmorFactory_Wildcard extends UT3ArmorPickupFactory;

var class<UT3ArmorPickup> PickupClasses[3];
var() bool bSequential;
const NumClasses = 3;
var int CurrentClass;

simulated function PostBeginPlay()
{
    local int i;

    CurrentClass = 3;
    RandomisePowerup();
    if ( Level.NetMode != NM_DedicatedServer )
    {
        for ( i=0; i< NumClasses; i++ )
            PickupClasses[i].static.StaticPrecache(Level);
    }
    Super.PostBeginPlay();
}

function TurnOn()
{
    RandomisePowerup();

    if( myPickup != None )
        myPickup = myPickup.Transmogrify(PowerUp);
    Super.TurnOn();
}

function RandomisePowerup()
{
    if (bSequential)
        CurrentClass = (CurrentClass+1)%NumClasses;
    else
        CurrentClass = Rand(NumClasses);

    PowerUp = PickupClasses[CurrentClass];
}

function SpawnPickup()
{
    if (PowerUp != None && PowerUp != PickupClasses[CurrentClass])
        RandomisePowerup();
    Super.SpawnPickup();
}

defaultproperties
{
    PickupClasses(0) = class'UT3ArmorVestPickup'
    PickupClasses(1) = class'UT3ArmorPickup_Thighpads'
    PickupClasses(2) = class'UT3ArmorPickup_Helmet'
}

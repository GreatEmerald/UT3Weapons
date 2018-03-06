/******************************************************************************
UT3TranslocatorDisk

Creation date: 2008-07-14 15:09
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3TranslocatorDisk extends TransBeacon abstract;

#exec obj load file=UT3A_Weapon_Translocator.uax

var() Sound DisruptSound;
var() Sound DisruptedSound;

simulated function HitWall( vector HitNormal, actor Wall )
{
    local CTFBase B;

    bCanHitOwner = true;

    Velocity = 0.3*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    Speed = VSize(Velocity);

    if ( Speed < 100 )
    {
        ForEach TouchingActors(class'CTFBase', B)
            break;

        if ( B != None )
        {
            Speed = VSize(Velocity);
            if ( Speed < 100 )
            {
                Speed = 90;
                Velocity = 90 * Normal(Velocity);
            }
            Disruption += 5;
            if ( Disruptor == None )
                Disruptor = Instigator;
        }
    }

            if ( Speed > 1 ) 
    {
        if ( Level.NetMode != NM_DedicatedServer )
            PlaySound(ImpactSound, SLOT_Misc );
        bBounce = true;
    }

    if ( Speed < 20 && Wall.bWorldGeometry && (HitNormal.Z >= 0.7) )
    {
        if ( Level.NetMode != NM_DedicatedServer )
            PlaySound(ImpactSound, SLOT_Misc );
        bBounce = false;
        SetPhysics(PHYS_None);

        if (Trail != None)
            Trail.mRegen = false;

        if ( (Level.NetMode != NM_DedicatedServer) && (Flare == None) )
        {
            Flare = Spawn(TransFlareClass, self,, Location - vect(0,0,5), rot(16384,0,0));
            Flare.SetBase(self);
        }
    }
}

simulated function Timer()
{
    if ( Level.NetMode == NM_DedicatedServer )
        return;

    if ( !Disrupted() )
    {
        SetTimer(0.3, false);
        return;
    }

    // create the disrupted effect
    if (Sparks == None)
    {
        Sparks = Spawn(class'TransBeaconSparks',,,Location+vect(0,0,5),Rotator(vect(0,0,1)));
        Sparks.SetBase(self);
        PlaySound(DisruptedSound, SLOT_Misc );
    }

    if (Flare != None)
        Flare.Destroy();
        PlaySound(DisruptSound, SLOT_Misc );
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    MyDamageType=class'DamTypeUT3TeleFrag'
    MaxSpeed=1330.000000
    Speed = 1330.0
    AmbientSound=None
    DisruptSound=Sound'UT3A_Weapon_Translocator.UT3TLDisrupted.UT3TLDisruptedCue'
    DisruptedSound=Sound'UT3A_Weapon_Translocator.UT3TLSingles.UT3TLDisruptedLoop'
    ImpactSound=Sound'UT3A_Weapon_Translocator.UT3TLBounce.UT3TLBounceCue'
    ImpactSound=Sound'UT3A_Weapon_Translocator.Bounce.BounceCue'
    SoundVolume=255
    SoundRadius=20
    TransientSoundVolume=2.0
    TransientSoundRadius=30.0
        
}

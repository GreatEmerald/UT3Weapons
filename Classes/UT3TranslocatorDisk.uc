/******************************************************************************
UT3TranslocatorDisk

Creation date: 2008-07-14 15:09
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3TranslocatorDisk extends TransBeacon abstract;

//=============================================================================
// Default values
//=============================================================================

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

defaultproperties
{
	Speed = 1330.0
}

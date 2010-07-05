/******************************************************************************
UT3Manta

Creation date: 2008-05-02 20:50
Last change: $Id$
Copyright (c) 2008, Wormbo and GreatEmerald
******************************************************************************/

class UT3Manta extends ONSHoverBike;

var Emitter DuckEffect;

simulated function CheckJumpDuck()
{
    local KarmaParams KP;
    local Emitter JumpEffect;
    local bool bOnGround;
    local int i;

    KP = KarmaParams(KParams);

    // Can only start a jump when in contact with the ground and not on water.
    bOnGround = false;
    for(i=0; i<KP.Repulsors.Length; i++)
    {
        if( KP.Repulsors[i] != None && KP.Repulsors[i].bRepulsorInContact )
            bOnGround = true;
    }

    // If we are on the ground, and press Rise, and we not currently in the middle of a jump, start a new one.
    if (JumpCountdown <= 0.0 && Rise > 0 && bOnGround && !bOverWater && !bHoldingDuck && Level.TimeSeconds - JumpDelay >= LastJumpTime)
    {
        PlaySound(JumpSound,,1.0);

        if (Role == ROLE_Authority)
           DoBikeJump = !DoBikeJump;

        if(Level.NetMode != NM_DedicatedServer)
        {
            JumpEffect = Spawn(class'ONSHoverBikeJumpEffect');
            JumpEffect.SetBase(Self);
            ClientPlayForceFeedback(JumpForce);
        }

        if ( AIController(Controller) != None )
            Rise = 0;

        LastJumpTime = Level.TimeSeconds;
    }
    else if (DuckCountdown <= 0.0 && (Rise < 0 || bWeaponIsAltFiring))
    {
        if (!bHoldingDuck)
        {
            bHoldingDuck = True;

            PlaySound(DuckSound,,1.0);

            if(Level.NetMode != NM_DedicatedServer)
            {
                DuckEffect = Spawn(class'UT3MantaDuckEffect');
                DuckEffect.SetBase(Self);
            }

            if ( AIController(Controller) != None )
                Rise = 0;

            JumpCountdown = 0.0; // Stops any jumping that was going on.
        }
    }
    else
       bHoldingDuck = False;
}

simulated function Tick(float DeltaTime)
{
  Super.Tick(DeltaTime);
  if (!bHoldingDuck && DuckEffect!=None) {
      DuckEffect.Destroy();
    }
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     JumpSound=Sound'UT3Vehicles.Manta.MantaJump'
     DuckSound=Sound'UT3Vehicles.Manta.MantaDuck'
     UprightStiffness=450.000000
     UprightDamping=20.000000
     MaxYawRate=3.000000
     RollTorqueMax=25.000000
     DriverWeapons(0)=(WeaponClass=Class'UT3Style.UT3MantaPlasmaGun')
     IdleSound=Sound'UT3Vehicles.Manta.MantaEngine'
     StartUpSound=Sound'UT3Vehicles.Manta.MantaEnter'
     ShutDownSound=Sound'UT3Vehicles.Manta.MantaLeave'
     VehicleNameString="UT3 Manta"
     HornSounds(1)=Sound'ONSVehicleSounds-S.Horns.LaCuchachaHorn'
}

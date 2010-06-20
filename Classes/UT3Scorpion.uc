/******************************************************************************
UT3Scorpion

Creation date: 2008-05-02 20:51
Since Alpha 2
Copyright (c) 2008 and 2009, Wormbo and GreatEmerald
******************************************************************************/

class UT3Scorpion extends EONSScorpion;

var IntBox BoostIconCoords, EjectIconCoords;
var float LastBoostAttempt;

event KImpact(actor other, vector pos, vector impactVel, vector impactNorm) //Modified so we would have control over when we detonate
{
   if (bPrimed)
   {
      bImminentDestruction = true;
//      if (Other != None && Other.IsA('ONSPRV'))
//         ImpactVel = vect(0,0,0);
      Super(ONSRV).KImpact(Other, Pos, ImpactVel, ImpactNorm);
   }
   if (VSize(impactVel) > 1000 && bImminentDestruction)
   {
      ImpactVel /= 100;
      if (Other != None && Other.IsA('ONSPRV'))
         ImpactVel = vect(0,0,0);
      SuperEjectDriver();
      HurtRadius(SelfDestructDamage, SelfDestructDamageRadius, SelfDestructDamageType, SelfDestructMomentum, Location);
      TakeDamage(SelfDestructDamage*3, Self, Location, vect(0,0,0), SelfDestructDamageType);
      Super(ONSRV).KImpact(Other, Pos, ImpactVel, ImpactNorm);
   }
}

simulated function DrawHUD(Canvas C)
{
	local PlayerController PC;

	Super.DrawHUD(C);

	// don't draw if we are dead, scoreboard is visible, etc
	PC = PlayerController(Controller);
	if (Health < 1 || PC == None || PC.myHUD == None || PC.MyHUD.bShowScoreboard )
		return;

	// draw tooltips
	if (BoostCount > 0 && !bBoost) //GE: BoostCount > 0 == bReadyToBoost ;)
		class'UT3HudOverlay'.static.DrawToolTip(C, PC, "Jump", C.ClipX*0.5, C.ClipY * 0.92, BoostIconCoords);
	else
	    class'UT3HudOverlay'.static.DrawToolTip(C, PC, "Jump", C.ClipX*0.5, C.ClipY * 0.92, EjectIconCoords);
}

simulated function Tick(float DT)
{
    local Coords ArmBaseCoords, ArmTipCoords;
    local vector HitLocation, HitNormal;
    local actor Victim;

    Super(ONSWheeledCraft).Tick(DT);

  if (Role == ROLE_Authority && IsHumanControlled() && Rise > 0 && Level.TimeSeconds - LastBoostAttempt > 1)
  {
     Boost();
     LastBoostAttempt = Level.TimeSeconds;
  }

  //If bImminentDestruction, then we have already primed the detonator and hit something - We detonate here because detonating in KImpact seemed to cause General Protection Faults in some circumstances
  if (bImminentDestruction)
  {
     GoToState('Ejecting');              //GE: Eject + delay + explosion
     return;
  }

  //If bAfterburnersOn and boost state don't agree
  if (bBoost != bAfterburnersOn)
  {
	   // it means we need to change the state of the vehicle (bAfterburnersOn)
	   // to match the desired state (bBoost)
     EnableAfterburners(bBoost); // show/hide afterburner smoke

	   // if we just enabled afterburners, set the timer
	   // to turn them off after set time has expired
	   if (bBoost)
	   {
	      SetTimer(BoostTime, false);
     }
	}

	if (Role == ROLE_Authority)
	{
	   // Afterburners recharge after the change in time exceeds the specified charge duration
	   BoostRechargeCounter+=DT;
	   if (BoostRechargeCounter > BoostRechargeTime)
	   {
	      if (BoostCount < 1)
	      {
           BoostCount++;
           if( PlayerController(Controller) != None)
           {
			        PlayerController(Controller).ClientPlaySound(BoostReadySound,,,SLOT_Misc);
           }
           //PlaySound(BoostReadySound, SLOT_Misc,128);
        }
        BoostRechargeCounter = 0;
	   }
	}

	// Left Blade Arm System
    if (Role == ROLE_Authority && bWeaponIsAltFiring && !bLeftArmBroke)
    {
        ArmBaseCoords = GetBoneCoords('CarLShoulder');
        ArmTipCoords = GetBoneCoords('LeftBladeDummy');
        Victim = Trace(HitLocation, HitNormal, ArmTipCoords.Origin, ArmBaseCoords.Origin);

        if (Victim != None && Victim.bBlockActors)
        {
            if (Victim.IsA('Pawn') && !Victim.IsA('Vehicle'))
                Pawn(Victim).TakeDamage(1000, self, HitLocation, Velocity * 100, class'DamTypeONSRVBlade');
            else
            {
                bLeftArmBroke = True;
                bClientLeftArmBroke = True;
                BladeBreakOff(4, 'CarLSlider', class'ONSRVLeftBladeBreakOffEffect');
                // We use slot 4 here because slots 0-3 can be used by BigWheels mutator.
            }
        }
    }
    if (Role < ROLE_Authority && bClientLeftArmBroke)
    {
        bLeftArmBroke = True;
        bClientLeftArmBroke = False;
        BladeBreakOff(4, 'CarLSlider', class'ONSRVLeftBladeBreakOffEffect');
    }

    // Right Blade Arm System
    if (Role == ROLE_Authority && bWeaponIsAltFiring && !bRightArmBroke)
    {
        ArmBaseCoords = GetBoneCoords('CarRShoulder');
        ArmTipCoords = GetBoneCoords('RightBladeDummy');
        Victim = Trace(HitLocation, HitNormal, ArmTipCoords.Origin, ArmBaseCoords.Origin);

        if (Victim != None && Victim.bBlockActors)
        {
            if (Victim.IsA('Pawn') && !Victim.IsA('Vehicle'))
                Pawn(Victim).TakeDamage(1000, self, HitLocation, Velocity * 100, class'DamTypeONSRVBlade');
            else
            {
                bRightArmBroke = True;
                bClientRightArmBroke = True;
                BladeBreakOff(5, 'CarRSlider', class'ONSRVRightBladeBreakOffEffect');
            }
        }
    }
    if (Role < ROLE_Authority && bClientRightArmBroke)
    {
        bRightArmBroke = True;
        bClientRightArmBroke = False;
        BladeBreakOff(5, 'CarRSlider', class'ONSRVRightBladeBreakOffEffect');
    }

}

simulated state Ejecting {
Begin:
     SuperEjectDriver();
     Sleep(1.0);
     HurtRadius(SelfDestructDamage, SelfDestructDamageRadius, SelfDestructDamageType, SelfDestructMomentum, Location);
     TakeDamage(SelfDestructDamage*3, Self, Location, vect(0,0,0), SelfDestructDamageType);
}

event Touch(actor Other)
{
    if (Other.IsA('Vehicle'))
    {
       Super.Touch(Other);
       if (bPrimed)
       {
          bImminentDestruction = true;
       }
    }
}

function Boost()
{
	//If we're already boosting, then prime the detonator
	/*if (bBoost)
	{
	  bImminentDestruction = true;
	  PlaySound(BoostReadySound, SLOT_Misc, 128,,,160);
	}*/

  // If we have a boost ready and we're not currently using it
	//log("UT3: Entering Boost!");
	//log("UT3: BoostRechargeTime: "@BoostRechargeTime);
	//log("UT3: BoostRechargeCounter: "@BoostRechargeCounter);
    if (BoostCount > 0 && !bBoost)
	{
    //log("UT3: Boosting!");
    BoostRechargeCounter=0;
	  PlaySound(BoostSound, SLOT_Misc, 128,,,64); //Boost sound Pitch 160
		bBoost = true;
		BoostCount--;
	}
	else {
	  //log("UT3: Kamikadze!");
      bImminentDestruction = true;
	  PlaySound(BoostReadySound, SLOT_Misc, 128,,,160);
	}
}

/*function VehicleFire(bool bWasAltFire)
{
	if (bWasAltFire)
	{
		Boost();
	}

    else Super(ONSWheeledCraft).VehicleFire(bWasAltFire);   //So we wouldn't shoot when boosting
}*/

function VehicleFire(bool bWasAltFire)
{
    if (bWasAltFire)
    {
       // Boost();
        PlayAnim('RVArmExtend');
        if (!bLeftArmBroke || !bRightArmBroke)
        {
            PlaySound(ArmExtendSound, SLOT_None, 2.0,,,, False);
            bWeaponIsAltFiring = True;
            ClientPlayForceFeedback(ArmExtendForce);
        }
    }
    else
        Super(ONSWheeledCraft).VehicleFire(bWasAltFire);
}

function AltFire(optional float F)
{
	//avoid sending altfire to weapon
    Super(Vehicle).AltFire(F);
}

function ClientVehicleCeaseFire(bool bWasAltFire)
{
    //avoid sending altfire to weapon
    if (bWasAltFire)
        Super(Vehicle).ClientVehicleCeaseFire(bWasAltFire);
    else
        Super(ONSWheeledCraft).ClientVehicleCeaseFire(bWasAltFire);
}

function ChooseFireAt(Actor A)
{
    if (Pawn(A) != None && Vehicle(A) == None && VSize(A.Location - Location) < 1500 && Controller.LineOfSightTo(A))
    {
        if (!bWeaponIsAltFiring)
            AltFire(0);
    }
    else if (bWeaponIsAltFiring)
        VehicleCeaseFire(true);

    Fire(0);
}

function VehicleCeaseFire(bool bWasAltFire)
{
    if (bWasAltFire)
    {
        PlayAnim('RVArmRetract');
        if (!bLeftArmBroke || !bRightArmBroke)
        {
            PlaySound(ArmRetractSound, SLOT_None, 2.0,,,, False);
            bWeaponIsAltFiring = False;
            ClientPlayForceFeedback(ArmRetractForce);
        }
    }
    else
        Super.VehicleCeaseFire(bWasAltFire);
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	VehicleNameString = "UT3 Scorpion"
	VehiclePositionString="in a Scorpion"
	RedSkin=Shader'VMVehicles-TX.RVGroup.RVChassisFinalRED'
    BlueSkin=Shader'VMVehicles-TX.RVGroup.RVChassisFinalBLUE'
    DriverWeapons(0)=(WeaponClass=Class'UT3ScorpionTurret',WeaponBone="ChainGunAttachment")
    bHasAltFire=False
    BoostForce=1800.000000
    SelfDestructDamage=600
    GroundSpeed=950.0000
    bHasHandBrake=False //GE: Override for the space bar?
    BoostSound=Sound'UT3Vehicles.SCORPION.ScorpionBoost'
    BoostReadySound=None
    //IdleSound=sound'UT3Vehicles.SCORPION.ScorpionEngine'
    StartUpSound=sound'UT3Vehicles.SCORPION.ScorpionStartUp'
    ShutDownSound=sound'UT3Vehicles.SCORPION.ScorpionExit'
    RanOverDamageType=class'DamTypeRVRoadkill'
    CrushedDamageType=class'DamTypeRVPancake'
    SelfDestructDamageType=class'UT3ScorpionSDDamage'
    BoostIconCoords = (X1=2,Y1=843,X2=97,Y2=50)
    EjectIconCoords = (X1=92,Y1=317,X2=50,Y2=50)
}

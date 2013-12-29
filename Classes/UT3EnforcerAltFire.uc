//==============================================================================
// UT3EnforcerFire.uc
// Three round burst - how?
// 2008, 2009, 2013 GreatEmerald
//==============================================================================

class UT3EnforcerAltFire extends UT3EnforcerFire;

var float ReBurstDelay;
var float StartFireTime;
var float AimErrorTime;
var int ServerFireCount;
var int DelayStopFire; // GEm: 0 - no delay, 1 - delay in progress, 2 - stop now

event ModeDoFire()
{
    if (!AllowFire())
        return;

    if (MaxHoldTime > 0.0)
        HoldTime = FMin(HoldTime, MaxHoldTime);

    if ( Level.TimeSeconds - LastFireTime > AimErrorTime )
        Spread = Default.Spread;
    else
        Spread = FMin(Spread+0.02,0.12);

    // server
    if (Weapon.Role == ROLE_Authority)
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
        DoFireEffect();
        HoldTime = 0;   // if bot decides to stop firing, HoldTime must be reset first
        if ( (Instigator == None) || (Instigator.Controller == None) )
            return;

        if ( AIController(Instigator.Controller) != None )
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

        Instigator.DeactivateSpawnProtection();
    }

    // client
    if (Instigator.IsLocallyControlled())
    {
        ShakeView();
        PlayFiring();
        FlashMuzzleFlash();
        StartMuzzleSmoke();
    }
    else // server
    {
        ServerPlayFiring();
    }

    Weapon.IncrementFlashCount(ThisModeNum);
    ServerFireCount++;

    // set the next firing time. must be careful here so client and server do not get out of sync
    if (bFireOnRelease)
    {
        if (bIsFiring)
            NextFireTime += MaxHoldTime + FireRate;
        else
            NextFireTime = Level.TimeSeconds + FireRate;
    }
    else
    {
        if (ServerFireCount < 3)
            NextFireTime += FireRate;
        else
        {
            NextFireTime += ReBurstDelay;
            ServerFireCount = 0;
            LastFireTime = Level.TimeSeconds;
            //StartFireTime = Level.TimeSeconds + ReBurstDelay;
            if (DelayStopFire == 1)
            {
                DelayStopFire = 2;
                Weapon.StopFire(1);
            }
        }
        NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
    }

    Load = AmmoPerFire;
    //HoldTime = 0;

    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
}

defaultproperties
{
     FireLoopAnim="weaponfireburst"
     FireAnim=
     FireRate=0.12
     ReBurstDelay=0.8667
     FireLoopAnimRate=1.3636
     StartFireTime=0.0
     AimErrorTime=1.42
}

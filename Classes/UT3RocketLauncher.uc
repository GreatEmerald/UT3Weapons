//=============================================================================
// UT3RocketLauncher.uc
// Rocket Scientist.
// 2008, 2013, 2014 GreatEmerald
//=============================================================================

class UT3RocketLauncher extends RocketLauncher;

var(Sound) Sound LockOnSound;
var(Sound) Sound LockLostSound;
var(Sound) Sound FireModeSwitchSound;
//var() Sound LoadStartSound;
//var() Sound LoadEndSound;
var enum ERocketFireMode
{
    RFM_Spread,
    RFM_Spiral,
    RFM_Grenades,
    RFM_None
} LoadedFireMode;

//var bool bClearFireMode;
var float FireModeSwitchTime; //GE: Time when the last switch in firing mode occured.
var float FireModeSwitchDelay; //GE: More than 0.2 when you hold the fire mode switch buttons.
var localized string SpiralName, GrenadesName;

var Material UDamageOverlay;
var() Sound PutDownSound;

replication
{
    // GEm: Make sure we tell the server when we want to switch fire modes
    reliable if (Role < ROLE_Authority)
        IncrementFireModeServer;
    // GEm: Have the server send us an all green
    reliable if (Role == ROLE_Authority)
        IncrementFireModeClient, LoadedFireMode, SetFireSoundClient;
}

function Tick(float dt)
{
    local Pawn Other;
    local Vector StartTrace;
    local Rotator Aim;
    local float BestDist, BestAim;

    if (Instigator == None || Instigator.Weapon != self)
        return;

    if ( Role < ROLE_Authority )
        return;

    if ( !Instigator.IsHumanControlled() )
        return;

    if (Level.TimeSeconds > SeekCheckTime)
    {
        if (bBreakLock)
        {
            bBreakLock = false;
            bLockedOn = false;
            SeekTarget = None;
        }

        StartTrace = Instigator.Location + Instigator.EyePosition();
        Aim = Instigator.GetViewRotation();

        BestAim = LockAim;
        Other = Instigator.Controller.PickTarget(BestAim, BestDist, Vector(Aim), StartTrace, SeekRange);

        if ( CanLockOnTo(Other) )
        {
            if (Other == SeekTarget)
            {
                LockTime += SeekCheckFreq;
                if (!bLockedOn && LockTime >= LockRequiredTime)
                {
                    bLockedOn = true;
                    PlayerController(Instigator.Controller).ClientPlaySound(LockOnSound);
                 }
            }
            else
            {
                SeekTarget = Other;
                LockTime = 0.0;
            }
            UnLockTime = 0.0;
        }
        else
        {
            if (SeekTarget != None)
            {
                UnLockTime += SeekCheckFreq;
                if (UnLockTime >= UnLockRequiredTime)
                {
                    SeekTarget = None;
                    if (bLockedOn)
                    {
                        bLockedOn = false;
                        PlayerController(Instigator.Controller).ClientPlaySound(LockLostSound);
                    }
                }
            }
            else
                 bLockedOn = false;
         }

        SeekCheckTime = Level.TimeSeconds + SeekCheckFreq;
    }
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local RocketProj Rocket;
    local SeekingRocketProj SeekingRocket;
    local bot B;

    bBreakLock = true;

    // decide if bot should be locked on
    B = Bot(Instigator.Controller);
    if ( (B != None) && (B.Skill > 2 + 5 * FRand()) && (FRand() < 0.6) && (B.Target != None)
        && (B.Target == B.Enemy) && (VSize(B.Enemy.Location - B.Pawn.Location) > 2000 + 2000 * FRand())
        && (Level.TimeSeconds - B.LastSeenTime < 0.4) && (Level.TimeSeconds - B.AcquireTime > 1.5) )
    {
        bLockedOn = true;
        SeekTarget = B.Enemy;
    }

    if (bLockedOn && SeekTarget != None)
    {
        SeekingRocket = Spawn(class'UT3SeekingRocketProj',,, Start, Dir);
        SeekingRocket.Seeking = SeekTarget;
        if ( B != None )
        {
            //log("LOCKED");
            bLockedOn = false;
            SeekTarget = None;
        }
        return SeekingRocket;
    }
    else
    {
        Rocket = Spawn(class'UT3RocketProj',,, Start, Dir);
        return Rocket;
    }
}

simulated event ClientStartFire(int Mode)
{
    local int OtherMode;

    if ( RocketMultiFire(FireMode[Mode]) != None )
    {
        //SetTightSpread(false);
    }
    else //if (bClearFireMode)
    {
        //bClearFireMode = False;
        OtherMode = int(!bool(Mode));

        if ( FireMode[OtherMode].bIsFiring || (FireMode[OtherMode].NextFireTime > Level.TimeSeconds) )
        {
            log("UT3RocketLauncher: ClientStartFire: IncrementFireMode");
            //if ( FireMode[OtherMode].Load > 0 )
                IncrementFireModeServer();
            if ( bDebugging )
                log("No RL reg fire because other firing "$FireMode[OtherMode].bIsFiring$" next fire "$(FireMode[OtherMode].NextFireTime - Level.TimeSeconds));
            return;
        }
    }
    Super(Weapon).ClientStartFire(Mode);
}

simulated event StopFire(int Mode)
{
    Super.StopFire(Mode);
    ClearFireMode(); //GE: Reset the fire mode on any stopFire since it won't get called on simple button release.
}

//GE: if bForce is true, disregard switch delay checks
//Used by bots for instant change
function IncrementFireModeServer(optional bool bForce)
{
    log("UT3RocketLauncher: IncrementFireMode: called");
    if (!bForce)
    {
        if ((FireModeSwitchTime+FireModeSwitchDelay) > Level.TimeSeconds)
        {
            if ((FireModeSwitchTime+FireModeSwitchDelay-0.1) <= Level.TimeSeconds)
                FireModeSwitchDelay += 0.1;               //Increases the time to wait by 0.1 seconds every 0.1 second
            return;                                       //Return if the last known switch time plus time to wait (initially 20 centiseconds) is even more then the current time
        }
        FireModeSwitchTime = Level.TimeSeconds;           //Since default float is 0 and TimeSeconds is always more than 0.2 by a lot, it initially passes
        FireModeSwitchDelay = 0.2;
    }

    //Instigator.ClientMessage("UT3RocketLauncher: LoadedFireMode before is"@int(LoadedFireMode));
    if (int(LoadedFireMode) >= 2)
        LoadedFireMode = RFM_Spread;
    else
        //LoadedFireMode = ERocketFireMode( int(LoadedFireMode) + 1 ); //GE: The hell?! One time it works, the other - doesn't!
    {
        switch(LoadedFireMode)
        {
            case RFM_Spread: LoadedFireMode=RFM_Spiral; break;
            case RFM_Spiral: LoadedFireMode=RFM_Grenades; break;
            case RFM_Grenades: LoadedFireMode=RFM_Spread; break;
            default: LoadedFireMode=RFM_None;
        }
    }
    //PlayOwnedSound(FireModeSwitchSound);
    IncrementFireModeClient();
    if (UT3RocketMultiFire(FireMode[1]) != None)
        UT3RocketMultiFire(FireMode[1]).SwitchFireMode(LoadedFireMode);
        //UT3RocketMultiFire(FireMode[1]).SwitchFireMode(LoadedFireMode);
    //Instigator.ClientMessage("UT3RocketLauncher: LoadedFireMode is"@LoadedFireMode);
}

simulated function IncrementFireModeClient()
{
    PlayOwnedSound(FireModeSwitchSound);
}

simulated function SetFireSoundClient(Sound NewSound)
{
    log("UT3RocketLauncher: SetFireSoundClient with"@NewSound);
    if (UT3RocketMultiFire(FireMode[1]) != None)
        UT3RocketMultiFire(FireMode[1]).FireSound = NewSound;
    log("UT3RocketLauncher: SetFireSoundClient: Set to"@UT3RocketMultiFire(FireMode[1]).FireSound);
}

simulated function ClearFireMode()
{
    LoadedFireMode = RFM_Spread;
    if (UT3RocketMultiFire(FireMode[1]) != None)
    {
        UT3RocketMultiFire(FireMode[1]).RecordMode();
        UT3RocketMultiFire(FireMode[1]).SwitchFireMode(RFM_Spread);
    }
}

simulated function string GetFireTypeStr()
{
    switch(LoadedFireMode)
    {
    case RFM_Spread: return "";
    case RFM_Spiral: return "["@SpiralName@"]";
    case RFM_Grenades: return "["@GrenadesName@"]";
    }
    return "ERR";
}

simulated event RenderOverlays(Canvas Canvas)
{
     Super.RenderOverlays(Canvas);
     if (GetFireTypeStr() == "")
        return;

     Canvas.Style = ERenderStyle.STY_Normal;
     Canvas.DrawColor = class'HUD'.Default.WhiteColor;
     Canvas.Font = Canvas.MedFont;
     Canvas.DrawScreenText(GetFireTypeStr(), 0.5, 0.54, DP_MiddleMiddle);
}

//GE: Reverting manual animation override.
simulated function RotateBarrel();
simulated function UpdateBarrel(float dt);
simulated function Plunge();
simulated function PlayFiring(bool plunge);
simulated function PlayLoad(bool full);
//simulated function BringUp(optional Weapon PrevWeapon) {Super(Weapon).BringUp(PrevWeapon);}
simulated state AnimateLoad {}
simulated function AnimEnd(int Channel) {Super(Weapon).AnimEnd(Channel);}

simulated state Loading
{
Begin:
    log("UT3RocketLauncher: State Loading");
    if (UT3RocketMultiFire(FireMode[1]) == None)
        GoToState('');
    UT3RocketMultiFire(FireMode[1]).Plunge(true);
    Sleep(0.2666); //GE: (Frames-1)/FrameRate 8, 18, 18
    //if (IsAnimating())
    //    StopAnimating();
    UT3RocketMultiFire(FireMode[1]).Plunge();
    Sleep(0.55);
    while (UT3RocketMultiFire(FireMode[1]).Load < 2.0)
        Sleep(0.01);
    //if (IsAnimating())
    //    StopAnimating();
    UT3RocketMultiFire(FireMode[1]).Plunge();
    Sleep(0.55);
    while (UT3RocketMultiFire(FireMode[1]).Load < 3.0)
        Sleep(0.01);
    //if (IsAnimating())
    //    StopAnimating();
    GoToState('');
}

state WaitForReload
{
Begin:
    Sleep(0.942);//Sleep(0.66);
    UT3RocketMultiFire(FireMode[1]).PlayReload();
    GoToState('');
}

simulated function PlayIdle()
{
    LoopAnim(IdleAnim, IdleAnimRate, 0.0);
}

simulated function SetOverlayMaterial(Material mat, float time, bool bOverride)
{
    Super.SetOverlayMaterial(mat, time, bOverride);
    if (OverlayMaterial == class'xPawn'.default.UDamageWeaponMaterial)
        OverlayMaterial = UDamageOverlay;
}

/*********************************************************************************************
 * AI Interface
 *********************************************************************************************/

function bool BotFire(bool bFinished, optional name FiringMode)
{
    local float Chance;

    Chance = FRand();

    if (BotMode == 1 && Chance < 0.66 ) //66% chance of the bot incrementing it once, 33% of twice
        IncrementFireModeServer(true);
    if (BotMode == 1 && FRand() < 0.33 )
        IncrementFireModeServer(true);
    return Super.BotFire(bFinished, FiringMode);
}

// GEm: Put down sound code below
simulated function BringUp(optional Weapon PrevWeapon)
{
   local int Mode;

    if ( ClientState == WS_Hidden )
    {
        PlayOwnedSound(SelectSound,,,,,, false);
                ClientPlayForceFeedback(SelectForce);  // jdf

        if ( Instigator.IsLocallyControlled() )
        {
            if ( (Mesh!=None) && HasAnim(SelectAnim) )
                PlayAnim(SelectAnim, SelectAnimRate, 0.0);
        }

        ClientState = WS_BringUp;
        SetTimer(BringUpTime, false);
    }
    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
        {
                FireMode[Mode].bIsFiring = false;
                FireMode[Mode].HoldTime = 0.0;
                FireMode[Mode].bServerDelayStartFire = false;
                FireMode[Mode].bServerDelayStopFire = false;
                FireMode[Mode].bInstantStop = false;
        }
           if ( (PrevWeapon != None) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
                OldWeapon = PrevWeapon;
        else
                OldWeapon = None;

}

simulated function bool PutDown()
{
    local int Mode;

    if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
    {
        if ( (Instigator.PendingWeapon != None) && !Instigator.PendingWeapon.bForceSwitch )
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                if ( FireMode[Mode].bFireOnRelease && FireMode[Mode].bIsFiring )
                    return false;
                if ( FireMode[Mode].NextFireTime > Level.TimeSeconds + FireMode[Mode].FireRate*(1.f - MinReloadPct))
                                        DownDelay = FMax(DownDelay, FireMode[Mode].NextFireTime - Level.TimeSeconds - FireMode[Mode].FireRate*(1.f - MinReloadPct));
            }
        }

        PlayOwnedSound(PutDownSound,,,,,, false);

        if (Instigator.IsLocallyControlled())
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                if ( FireMode[Mode].bIsFiring )
                    ClientStopFire(Mode);
            }

            if (  DownDelay <= 0 )
            {
                                if ( ClientState == WS_BringUp )
                                        TweenAnim(SelectAnim,PutDownTime);
                                else if ( HasAnim(PutDownAnim) )
                                        PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
                        }
        }
        ClientState = WS_PutDown;
        if ( Level.GRI.bFastWeaponSwitching )
                        DownDelay = 0;
        if ( DownDelay > 0 )
                        SetTimer(DownDelay, false);
                else
                        SetTimer(PutDownTime, false);
    }
    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
    {
                FireMode[Mode].bServerDelayStartFire = false;
                FireMode[Mode].bServerDelayStopFire = false;
        }
    Instigator.AmbientSound = None;
    OldWeapon = None;
    return true; // return false if preventing weapon switch
}

defaultproperties
{
    ItemName="UT3 Rocket Launcher"
    Description="Each year, more accidental deaths are caused by the Trident Tri-barrel Rocket Launcher than in vehicular accidents and extreme sports combined. The kill radius for its standard dumbfire rocket is surprisingly high by design - so accidentally firing upon a nearby wall, or a nearby enemy soldier, can be quite fatal for the operator. The alternate fire adds to this suicidal lethality by loading and firing up to three rockets at once, in a spread, tight spiral, or lobbed like grenades. Regardless of the grim statistics, veteran soldiers still consider the 'old 8 ball' the most expedient way to put explosive ordnance on target."

    FireModeClass(0)=UT3RocketFire
    FireModeClass(1)=UT3RocketMultiFire
    PickupClass=class'UT3RocketLauncherPickup'
    AttachmentClass=class'UT3RocketAttachment'
    SelectSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherTakeOut'
    LockOnSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherSeekLock'
    LockLostSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherSeekLost'
    FireModeSwitchSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherAltModeChange'
    LockRequiredTime=1.10000
    LockAim=0.997000
    SeekCheckFreq=0.100000
    //LoadStartSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherLoad1'
    //LoadEndSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherLoad2'
    TransientSoundVolume=0.6
    AIRating=0.78
    CurrentRating=0.780000

    Priority=10
    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairRocketLauncher"
    CustomCrosshairColor=(B=0,G=0,R=255,A=255)
    CustomCrosshairScale=1.2
    HudColor=(B=0,G=0,R=255,A=255)
    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=65,Y1=189,X2=130,Y2=214)

    IdleAnim="WeaponIdle"
    RestAnim="WeaponIdle"
    AimAnim="WeaponIdle"
    RunAnim="WeaponIdle"
    SelectAnim="WeaponEquip"
    PutDownAnim="WeaponPutDown"
    BringUpTime=0.6
    IdleAnimRate=1.000000
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_RocketLauncher_1P'
    HighDetailOverlay=None
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'
    PutDownSound=Sound'UT3Weapons2.RocketLauncher.A_Weapon_RL_Lower02'

    SpiralName="Spiral"
    GrenadesName="Grenades"

    PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
    PlayerViewOffset=(X=0.0,Y=8.0,Z=1.2)
    SmallViewOffset=(X=8,Y=12,Z=-2)
}

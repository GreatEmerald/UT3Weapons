//=============================================================================
// UT3AVRIL.uc
// Not sure why Wormbo chose "AVRIL" instead of "AVRiL".
// 2008, 2013, 2014 GreatEmerald
//=============================================================================

class UT3AVRIL extends ONSAVRiL;

#EXEC OBJ LOAD FILE=UT3A_Weapon_AVRiL.uax

var() Sound LockOnSound;
//var bool bDebug1, bDebug2, bDebug3;
var Material UDamageOverlay;
var() Sound PutDownSound;

simulated function WeaponTick(float deltaTime)
{
    local vector StartTrace, LockTrace;
    local rotator Aim;
    local float BestAim, BestDist;
    local bool bLastLockedOn, bBotLock;
    local Vehicle LastHomingTarget;
    local Vehicle AIFocus;
    local Vehicle V;
    local Actor AlternateTarget;

    if (Role < ROLE_Authority)
    {
        ActivateReticle(bLockedOn);
        return;
    }

    if (Instigator == None || Instigator.Controller == None)
    {
        LoseLock();
        ActivateReticle(false);
        return;
    }

    if (Level.TimeSeconds < LockCheckTime)
        return;

    //Instigator.ClientMessage("UT3AVRIL: Lock is"@bLockedOn@"and target is"@HomingTarget);

    LockCheckTime = Level.TimeSeconds + LockCheckFreq;

    bLastLockedOn = bLockedOn;
    LastHomingTarget = HomingTarget;
    bBotLock = true;
    if (AIController(Instigator.Controller) != None)
    {
        AIFocus = Vehicle(AIController(Instigator.Controller).Focus);
        if ( CanLockOnTo(AIFocus) && ((AIFocus.Controller != None) || (AIFocus != Instigator.Controller.MoveTarget) || AIFocus.HasOccupiedTurret())
            && FastTrace(AIFocus.Location, Instigator.Location + Instigator.EyeHeight * vect(0,0,1)) )
        {
            HomingTarget = AIFocus;
            bLockedOn = true;
        }
        else
        {
            bLockedOn = false;
            bBotLock = false;
        }
    }
    else if ( HomingTarget == None || Normal(HomingTarget.Location - Instigator.Location) Dot vector(Instigator.Controller.Rotation) < LockAim
          || VSize(HomingTarget.Location - Instigator.Location) > MaxLockRange
          || !FastTrace(HomingTarget.Location, Instigator.Location + Instigator.EyeHeight * vect(0,0,1)) )
    {
        StartTrace = Instigator.Location + Instigator.EyePosition();
        Aim = Instigator.GetViewRotation();
        BestAim = LockAim;

        HomingTarget = Vehicle(Instigator.Controller.PickTarget(BestAim, BestDist, Vector(Aim), StartTrace, MaxLockRange));
    }

    // If no homing target, check for alternate targets
    if (HomingTarget == None)
    {
        StartTrace = Instigator.Location + Instigator.EyePosition();
        Aim = Instigator.GetViewRotation();

        for (V = Level.Game.VehicleList; V != None; V = V.NextVehicle)
        {
            AlternateTarget = V.AlternateTarget();

            if (AlternateTarget != None)
            {
                LockTrace = AlternateTarget.Location - StartTrace;
                if ( (Normal(LockTrace) dot Vector(Aim)) > LockAim && VSize(LockTrace) < MaxLockRange && FastTrace(AlternateTarget.Location,StartTrace) )
                {
                    HomingTarget = V;
                    if ( AIController(Instigator.Controller) != none)
                        AIController(Instigator.Controller).Focus = V;
                    break;
                }
            }
        }
    }

    bLockedOn = CanLockOnTo(HomingTarget);

    ActivateReticle(bLockedOn);
    if (!bLastLockedOn && bLockedOn)
    {
        if ( bBotLock && (HomingTarget != None) )
            HomingTarget.NotifyEnemyLockedOn();
        if ( PlayerController(Instigator.Controller) != None )
            PlayerController(Instigator.Controller).ClientPlaySound(LockOnSound);  //<-- Take two of these and call me when you get to HELL!!
    }
    else if (bLastLockedOn && !bLockedOn && LastHomingTarget != None)
        LastHomingTarget.NotifyEnemyLostLock();
}

simulated function ActivateReticle(bool bActivate); //GE: Moar Hax!11 Seriously, since when did Epic use so many hacks?!

simulated function PostBeginPlay()
{
    Super(Weapon).PostBeginPlay();
}

//GE: Allow us to see the weapon at all times.
simulated event RenderOverlays(Canvas Canvas)
{
    if (bLockedOn)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
        Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
    }

    Super(Weapon).RenderOverlays(Canvas);
}

function bool CanLockOnTo(Actor Other)
{
    local Vehicle V;
    V = Vehicle(Other);

    if (V == None || V == Instigator || V.bVehicleDestroyed) //GE: Enh - don't lock on corpses
        return false;

    if (!Level.Game.bTeamGame)
        return true;

    return (V.Team != Instigator.PlayerReplicationInfo.Team.TeamIndex);
}

simulated function bool StartFire(int Mode)
{
    if (UT3AVRiLAttachment(ThirdPersonActor) != None && Mode == 0)
        UT3AVRiLAttachment(ThirdPersonActor).PlayFiring();
    return Super.StartFire(Mode);
}

simulated function SetOverlayMaterial(Material mat, float time, bool bOverride)
{
    Super.SetOverlayMaterial(mat, time, bOverride);
    if (OverlayMaterial == class'xPawn'.default.UDamageWeaponMaterial)
        OverlayMaterial = UDamageOverlay;
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
    ItemName="UT3 Longbow AVRiL"
    Description="The Longbow Anti-Vehicle Rocket Launcher, a.k.a. the 'AVRiL', gives dismounted infantry a fighting chance in an armored conflict. Its solid fuel missile can be 'dumbfired' as an unguided rocket, but the AVRiL's famed kill percentages come from its optical tracking system.|The alternate fire zooms and locks on to a vehicle, guiding the missile towards its target at inescapable speeds. The missile's microdappled control planes use increased surface area to give unprecedented turning radius, guaranteeing delivery of its shaped PolyDiChlorite charge into all but the most nimble vehicles.|The AVRiL is notoriously slow to reload, so it should be employed with caution in a pitched battle.|Note, the Longbow's targeting laser is (not yet) standardized for most Axon military equipment, so it can be used in other battlefield applications such as directing spider mines."  //TODO Lasers
    

    IdleAnim="WeaponIdle"
    RestAnim="WeaponIdle"
    AimAnim="WeaponIdle"
    RunAnim="WeaponIdle"
    SelectAnim="WeaponEquip"
    PutDownAnim="WeaponPutDown"
    SelectAnimRate=0.8
    PutDownAnimRate=0.8
    IdleAnimRate=0.8
    RestAnimRate=0.8
    RunAnimRate=0.8
    AimAnimRate=0.8
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Avril_1P'
    BringUpTime=0.5833
    PlayerViewOffset=(X=40.0,Y=15.0,Z=-8.0)
    SmallViewOffset=(X=85.0,Y=27.0,Z=-20.0)
    PlayerViewPivot=(Pitch=500,Roll=0,Yaw=-500) //Pitch: +=Z Yaw:-=X
    DrawScale=0.4

    FireModeClass(0)=UT3AVRiLFire
    FireModeClass(1)=UT3AVRiLAltFire
    //ReticleOFFMaterial=Shader'VMWeaponsTX.PlayerWeaponsGroup.AVRiLreticleTEX'
    //ReticleONMaterial=Shader'VMWeaponsTX.PlayerWeaponsGroup.AVRiLreticleTEXRed'

    PickupClass=class'UT3AVRiLPickup'
    SelectSound=Sound'UT3A_Weapon_AVRiL.WeaponEquip.EquipCue'
    PutDownSound=Sound'UT3A_Weapon_AVRiL.WeaponUnEquip.UnEquipCue'
    LockOnSound=Sound'UT3A_Weapon_AVRiL.Singles.Lock01'
    TransientSoundVolume=0.8

    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairAVRiL"
    CustomCrosshairColor=(B=0,G=0,R=255,A=255)
    CustomCrosshairScale=1.2
    HudColor=(B=0,G=0,R=255,A=255)

    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=364,Y1=213,X2=435,Y2=238)

    AttachmentClass=Class'UT3AVRiLAttachment'
    
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'
    
}

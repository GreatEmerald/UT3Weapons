//==============================================================================
// UT3Enforcer.uc
// Death warrant - enforced.
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3Enforcer extends AssaultRifle;

var name ReloadAnim, AkimboTransTAnim, AkimboFireAnim, AkimboPutDownAnim;
var name AkimboIdleAnim, AkimboIdleBAnim, AkimboTransFAnim, AkimboBurstAnim;
var Sound ReloadSound;
var bool bAlreadyLoaded;
var float ReloadAnimRate;
var bool bAkimbo; //Whether we are currently holding weapons to the side.
var() float AkimboTime; //How long transition to akimbo takes
var float LastAkimboTransitionTime; //Time that last akimbo transition occured.
var float AkimboDelay;
var enum ETimerSetting //GE: For emulating UT3/U2XMP sophisticated Timer third parameter
{
    TS_None,
    TS_AkimboDelay,
    TS_AkimboCheck
} TimerSetting;

simulated event RenderOverlays( Canvas Canvas )
{
    local int RealHand;

    if (Instigator == None)
        return;

    if ( Instigator.Controller != None )
        Hand = Instigator.Controller.Handedness;

    if ((Hand < -1.0) || (Hand > 1.0))
        return;

    RealHand = Hand;
    if ( bDualMode && (Hand == 0) )
    {
        Instigator.Controller.Handedness = -1;
        Hand = -1;
    }
    Super(Weapon).RenderOverlays(Canvas);

    if ( bDualMode )
        RenderDualOverlay(Canvas);
    if ( Instigator.Controller != None )
        Instigator.Controller.Handedness = RealHand;
}

simulated function RenderDualOverlay(Canvas Canvas)
{
    local vector NewScale3D;
    local rotator WeaponRotation;

    Hand *= -1;
    newScale3D = Default.DrawScale3D;
    newScale3D.Y *= Hand;
    SetDrawScale3D(newScale3D);
    PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll * Hand;
    PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw * Hand;
    RenderedHand = Hand;

    if ( class'PlayerController'.Default.bSmallWeapons )
        PlayerViewOffset = SmallViewOffset;
    else
        PlayerViewOffset = Default.PlayerViewOffset;

    PlayerViewOffset.Y *= Hand;

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    WeaponRotation = Instigator.GetViewRotation();

    if ( bDualMode != bWasDualMode )
    {
        bWasDualMode = true;
        DualPickupTime = Level.Timeseconds;
    }
    if ( DualPickupTime > Level.TimeSeconds - 0.5 )
        WeaponRotation.Pitch = WeaponRotation.Pitch - 16384 - 32768 * (DualPickupTime - Level.TimeSeconds);

    SetRotation( WeaponRotation );

    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);

    bDrawingFirstPerson = false;
    Hand *= -1;
}

simulated function Destroyed()
{
    DetachFromPawn(Instigator);
    Super.Destroyed();
}

simulated function DetachFromPawn(Pawn P)
{
    bFireLeft = false;
    Super(Weapon).DetachFromPawn(P);
    if ( OffhandActor != None )
    {
        OffhandActor.Destroy();
        OffhandActor = None;
    }
}

function AttachToPawn(Pawn P)
{
    local name BoneName;

    if ( ThirdPersonActor == None )
    {
        ThirdPersonActor = Spawn(AttachmentClass,Owner);
        InventoryAttachment(ThirdPersonActor).InitFor(self);
    }
    BoneName = P.GetWeaponBoneFor(self);
    if ( BoneName == '' )
    {
        ThirdPersonActor.SetLocation(P.Location);
        ThirdPersonActor.SetBase(P);
    }
    else
        P.AttachToBone(ThirdPersonActor,BoneName);

    if ( bDualMode )
    {
        BoneName = P.GetOffHandBoneFor(self);
        if ( BoneName == '' )
            return;
        if ( OffhandActor == None )
        {
            OffhandActor = AssaultAttachment(Spawn(AttachmentClass,Owner));
            OffhandActor.InitFor(self);
        }
        P.AttachToBone(OffhandActor,BoneName);
        if ( OffhandActor.AttachmentBone == '' )
            OffhandActor.Destroy();
        else
        {
            OffhandActor.SetDrawScale(ThirdPersonActor.DrawScale);
            OffhandActor.bDualGun = true;
            OffhandActor.TwinGun = AssaultAttachment(ThirdPersonActor);
            if ( Mesh == OldMesh ) //GE: I think this is obsolete.
            {
                OffhandActor.SetRelativeRotation(rot(0,32768,0));
                OffhandActor.SetRelativeLocation(vect(20,-10,-5));
            }
            else
            {
                OffhandActor.SetRelativeRotation(rot(0,0,32768));
                OffhandActor.SetRelativeLocation(vect(-42,18,-32));
            }
            AssaultAttachment(ThirdPersonActor).TwinGun = OffhandActor;
        }
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    local int Mode;

    if ( ClientState == WS_Hidden )
    {
        if (bAlreadyLoaded)
          PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
        ClientPlayForceFeedback(SelectForce);  // jdf

        if ( Instigator.IsLocallyControlled() )
        {
                  if (!bAlreadyLoaded)
                  {
                    if ( (Mesh!=None) && HasAnim(ReloadAnim) )
                    {
                      PlayAnim(ReloadAnim, ReloadAnimRate);
                      BringUpTime = AkimboDelay;
                      TimerSetting = TS_AkimboDelay;
                      SetTimer(AkimboDelay, False);
                    }
                    PlayOwnedSound(ReloadSound, SLOT_Interact, TransientSoundVolume*1.5,,,, false);
                    bAlreadyLoaded = true;
                  }

            else if ( (Mesh!=None) && HasAnim(SelectAnim) )
                PlayAnim(SelectAnim, SelectAnimRate, 0.0);
        }

        ClientState = WS_BringUp;
        SetTimer(BringUpTime, false);
        BringUpTime = Default.BringUpTime;
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
    TimerSetting = TS_None;
    //SetTimer(0.0, False); //GE: It's already taken care of in Super()
    return Super.PutDown();
}

simulated function Timer()
{
    if (TimerSetting == TS_AkimboDelay)
    {
        Super.Timer();
        DelayAkimbo();
    }

    else if (TimerSetting == TS_AkimboCheck)
    {
        Super.Timer();
        AkimboCheck();
    }

    else
        Super.Timer();
}

simulated function DelayAkimbo()
{
    TimerSetting = TS_AkimboCheck;
    SetTimer(0.25, TRUE);
}

simulated function AkimboCheck()
{
    local vector HitLocation, HitNormal;
    local pawn HitPawn;

    // Go akimbo if you are shooting a dead thing within 300 units, or a live thing within 150
    HitPawn = Pawn( Trace(HitLocation, HitNormal, Location + ((300 * vect(1,0,0)) >> Rotation), Location, TRUE) );
    if(HitPawn != None && (HitPawn.Health <= 0 || VSize(HitLocation - Location) < 200.0)
        && ((Instigator.PlayerReplicationInfo != None && HitPawn.PlayerReplicationInfo != None
        && (Instigator.PlayerReplicationInfo.Team != HitPawn.PlayerReplicationInfo.Team || HitPawn.PlayerReplicationInfo.bNoTeam)) || (HitPawn.PlayerReplicationInfo == None)))
    {
        SetAkimbo(TRUE, TRUE);
    }
    else
    {
        SetAkimbo(FALSE, TRUE);
    }
}

simulated function SetAkimbo(bool bNewAkimbo, bool bPlayTransitionAnim)
{
    // Only allow one transition every second
    if(bPlayTransitionAnim && ((Level.TimeSeconds - LastAkimboTransitionTime) < 1.0))
    {
        return;
    }

    if(bNewAkimbo && !bAkimbo)
    {
        if(bPlayTransitionAnim && Level.NetMode != NM_DedicatedServer)
        {
            PlayAnim(AkimboTransTAnim, AkimboTime);
        }

        FireMode[0].FireAnim=AkimboFireAnim;
        FireMode[1].FireLoopAnim=AkimboBurstAnim;

        PutDownAnim=AkimboPutDownAnim;
        IdleAnim=AkimboIdleAnim;
        RunAnim=AkimboIdleAnim;
        RestAnim=AkimboIdleBAnim;
        AimAnim=AkimboIdleBAnim;

        LastAkimboTransitionTime = Level.TimeSeconds;
        bAkimbo = TRUE;
    }
    else if(!bNewAkimbo && bAkimbo)
    {
        if(bPlayTransitionAnim)
        {
            PlayAnim(AkimboTransFAnim, AkimboTime);
        }

        FireMode[0].FireAnim=FireMode[0].default.FireAnim;
        FireMode[1].FireLoopAnim=FireMode[1].default.FireLoopAnim;

        PutDownAnim=default.PutDownAnim;
        IdleAnim=default.IdleAnim;
        RunAnim=default.RunAnim;
        RestAnim=default.RestAnim;
        AimAnim=default.AimAnim;

        LastAkimboTransitionTime = Level.TimeSeconds;
        bAkimbo = FALSE;
    }
}

simulated function float ChargeBar()
{
return 0;
}

function bool HandlePickupQuery( pickup Item )
{
    if ( class == Item.InventoryType )
    {
        if ( bDualMode )
            return super(Weapon).HandlePickupQuery(Item);
        bDualMode = true;
        if ( Instigator.Weapon == self )
        {
            PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
            AttachToPawn(Instigator);
        }
        if (Level.GRI.WeaponBerserk > 1.0)
            CheckSuperBerserk();
        else
        {
            FireMode[0].FireRate = FireMode[0].Default.FireRate *  0.55;
            if (UT3EnforcerAltFire(FireMode[1]) != None )
            {
                UT3EnforcerAltFire(FireMode[1]).ReBurstDelay = UT3EnforcerAltFire(FireMode[1]).default.ReBurstDelay * 0.55;
            }
        }

        FireMode[0].Spread = FireMode[0].Default.Spread * 1.5;
        FireMode[1].Spread = FireMode[1].Default.Spread * 1.5;
        if (xPawn(Instigator) != None && xPawn(Instigator).bBerserk)
            StartBerserk();

        return false;
    }

        if ( item.inventorytype == AmmoClass[0] )
    {
        if (AmmoCharge[0] >= MaxAmmo(0))
            return true;
        item.AnnouncePickup(Pawn(Owner));
        //AddAmmo(16, 0);
        AddAmmo(Ammo(item).AmmoAmount, 0);
        item.SetRespawn();
        return true;
    }

     if ( Inventory == None )
        return false;

    return Inventory.HandlePickupQuery(Item);
}

simulated function NewDrawWeaponInfo(Canvas Canvas, float YPos)
{
}

/*function byte BestMode()
{
    local float EnemyDist;
    local bot B;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return 0;

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if ( EnemyDist < 1000 )
        return 1;
    return 0;
} */

function byte BestMode()
{
    local Bot B;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) || (B.Skill * FRand() < 1.5) )
    {
        return 0;
    }

    // use burst fire at short range
    if ( VSize(B.Enemy.Location - Instigator.Location) < 500.0 )
        return 1;
    return 0;
}

simulated function bool StartFire(int Mode)
{
    if (UT3EnforcerAltFire(FireMode[Mode]) != None)
        UT3EnforcerAltFire(FireMode[Mode]).StartFireTime = Level.TimeSeconds;
    return Super.StartFire(Mode);
}

simulated event StopFire(int Mode)
{
    if (UT3EnforcerAltFire(FireMode[Mode]) != None && Level.TimeSeconds - UT3EnforcerAltFire(FireMode[Mode]).StartFireTime < 3*FireMode[Mode].FireRate)
        return;

    Super.StopFire(Mode);
}

defaultproperties
{
    Description="For decades, the Enforcer pistol was the combat sidearm of choice. Veteran soldiers appreciated the lightweight handgun's power, accuracy, and balance. In recent years, the ever-burning desire for greater firepower led to general issue of the AR770 assault rifle. Military procurement officers were drawn to the AR770's higher cyclic rate and underslung M355 grenade launcher, but seasoned combatants missed the dependability of the Enforcer. Axon Research listened to the soldiers, and their new Enforcer MP ('Machine Pistol') model provides the best of both worlds. Side-fed magazines provide greater capacity, while balancing the shooter's aim when wielding two pistols. With a deadly accurate semi-automatic mode, and a selectable burst fire mode, the Enforcer is back, and the modern battlefield will never be the same."
    ItemName="UT3 Enforcer"

    bShowChargingBar=false
    FireModeClass(0)=UT3EnforcerFire
    FireModeClass(1)=UT3EnforcerAltFire
    PickupClass=class'UT3EnforcerPickup'
    SelectSound=Sound'UT3Weapons.Enforcer.EnforcerTakeOut'

    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairEnforcer"
	CustomCrosshairColor=(R=255,G=255,B=255,A=255)
	CustomCrosshairScale=1.2
	HudColor=(R=255,G=255,B=255,A=255)

	IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=299,Y1=171,X2=355,Y2=199)

    //Priority=2.000000
   //AIRating=0.400000

     AkimboTransTAnim="weapontranition_toside"
     AkimboTransFAnim="weapontranition_fromside"
     AkimboFireAnim="weaponfire_side"
     AkimboBurstAnim="weaponfireburst_side"
     AkimboPutDownAnim="weaponputdown_side"
     AkimboIdleAnim="weaponidle_side"
     AkimboIdleBAnim="WeaponIdleB_Side"

     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdleB"
     AimAnim="WeaponIdleB"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     ReloadAnim="weaponequipempty"
     ReloadAnimRate=1.3636
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Enforcers_1P'
     OldMesh=None
     DrawScale=1.000000
     PlayerViewOffset=(X=10.0,Y=-10.0,Z=7.0)
     SmallViewOffset=(X=60.0,Y=12.0,Z=-13.0)
     PlayerViewPivot=(Pitch=-500,Yaw=750,Roll=0)
     AttachmentClass=class'UT3EnforcerAttachment'
     ReloadSound=Sound'UT3Weapons2.Enforcer.EnforcerReload'
     bAlreadyLoaded=False
     AkimboDelay=2.0
     AkimboTime=1.3636
     HighDetailOverlay=None
}

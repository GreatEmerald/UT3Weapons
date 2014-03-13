//==============================================================================
// UT3ImpactHammer.uc
// The Impact Hammer!
// 2008, 2013, 2014 GreatEmerald
//==============================================================================

class UT3ImpactHammer extends ShieldGun;

var Material UDamageOverlay;
var() Sound PutDownSound;

// TODO: AI rating

simulated function float ChargeBar()
{
    if (FireMode[0].HoldTime >= UT3ImpactHammerFire(FireMode[0]).FullyChargedTime ||
        FireMode[1].HoldTime >= UT3ImpactHammerEMPFire(FireMode[1]).FullyChargedTime)
        Skins[0] = Material'UT3WeaponSkins.ImpactHammer.ImpactHammerActive';
    else
        Skins[0] = default.Skins[0];

    if (FireMode[0].bIsFiring)
        return FMin(1,FireMode[0].HoldTime/UT3ImpactHammerFire(FireMode[0]).FullyChargedTime);
    else if (FireMode[1].bIsFiring)
        return FMin(1,FireMode[1].HoldTime/UT3ImpactHammerEMPFire(FireMode[1]).FullyChargedTime);
    return 0;
}

function DoReflectEffect(int Drain)
{
}

simulated function ClientTakeHit(int Drain)
{
}

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int AmmoDrain )
{
return false;
}

function AdjustPlayerDamage( out int Damage, Pawn InstigatedBy, Vector HitLocation,
                                 out Vector Momentum, class<DamageType> DamageType)
{
}

simulated function float AmmoStatus(optional int Mode) // returns float value for ammo amount
{
    return Super(Weapon).AmmoStatus(Mode);
}

simulated function AnimEnd(int channel)
{
    if (FireMode[0].bIsFiring || FireMode[1].bIsFiring)
    {
        LoopAnim('WeaponChargedIdle', , , channel);
        if (UT3ImpactHammerAttachment(ThirdPersonActor) != None)
            UT3ImpactHammerAttachment(ThirdPersonActor).PlayCharged();
    }
    else
        Super(Weapon).AnimEnd(channel);
}

function byte BestMode()
{
    local bot B;

    B = Bot(Instigator.Controller);

    if (B == None || B.Enemy == None)
    {
        return 0;
    }
    else if (Vehicle(B.Enemy) != None)
    {
        return 1;
    }
    else if (B.Skill + B.Tactics < 1.0 + 2.0 * FRand())
    {
        return 0;
    }
    return 0;

}

function FireHack(byte Mode)
{
    if ( Mode == 0 )
    {
        FireMode[0].PlayFiring();
        FireMode[0].FlashMuzzleFlash();
        FireMode[0].StartMuzzleSmoke();
        IncrementFlashCount(0);
    }
    else if ( Mode == 1 )
    {
        FireMode[1].PlayFiring();
        FireMode[1].FlashMuzzleFlash();
        FireMode[1].StartMuzzleSmoke();
        IncrementFlashCount(1);
    }
}

function float GetAIRating()
{
    local Bot B;
    local float EnemyDist;

    B = Bot(Instigator.Controller);
    if (B == None)
    {
        return AIRating;
    }
    // super desireable for bot waiting to impact jump
    if (B.bPreparingMove && B.ImpactTarget != None)
    {
        return 9.f;
    }

    if (B.Enemy == None)
    {
        return AIRating;
    }

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if (B.Stopped() && EnemyDist > 100.f)
    {
        return 0.1;
    }
    if (EnemyDist < 750.f && B.Skill <= 2 && UT3ImpactHammer(B.Enemy.Weapon) != None)
    {
        return FClamp(300.f / (EnemyDist + 1.f), 0.6, 0.75);
    }
    if (EnemyDist > 400)
    {
        return 0.1;
    }
    if (Instigator.Weapon != self && EnemyDist < 120)
    {
        return 0.25;
    }
    return FMin(0.6, 90.f / (EnemyDist + 1.f));
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
    ItemName = "UT3 Impact Hammer"
    Description="The Impact Hammer, originally designed for sub-surface drift mining, can focus several hundred metric tons of pressure into the space of a few square centimeters. The impact, and resulting shock wave, easily destabilizes solid stone to speed ore separation and excavation. After several mining accidents highlighted the Hammer's devastating effect on the human body, the N.E.G. military took interest. To improve the Hammer's effectiveness against vehicles with shock-absorbing armor, an alternate electromagnetic pulse (EMP) mode was added. The EMP violently scrambles onboard computer systems, quickly leading to engine failure. Field testing showed the EMP has a similar effect on infantry powerups, knocking them off soldiers and enabling battlefield recovery."

    FireModeClass(0) = class'UT3ImpactHammerFire'
    FireModeClass(1) = class'UT3ImpactHammerEMPFire'

    PickupClass     = class'UT3ImpactHammerPickup'
    AttachmentClass = class'UT3ImpactHammerAttachment'

    SelectSound = Sound'UT3Weapons.ImpactHammer.ImpactHammerTakeOut'

    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairImpactHammer"
    CustomCrosshairScale=1.5
    CustomCrosshairColor=(B=128,G=255,R=255,A=255)
    HudColor=(B=128,G=255,R=255,A=255)

    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=226,Y1=162,X2=294,Y2=191)

    //Priority=1.000000
    //AIRating=0.350000

    HighDetailOverlay=None
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Impact_1P'
    IdleAnim="WeaponIdle"
    RestAnim="WeaponIdle"
    AimAnim="WeaponIdle"
    RunAnim="WeaponIdle"
    SelectAnim="WeaponEquip"
    PutDownAnim="WeaponPutDown"
    SelectAnimRate=1.3636
    BringUpTime=0.5133

    PlayerViewPivot=(Pitch=500,Yaw=-500,Roll=0)
    PlayerViewOffset=(X=3.0,Y=0.5,Z=-0.5)
    SmallViewOffset=(X=9,Y=3,Z=-3)
    Skins(0)=Material'UT3WeaponSkins.ImpactHammer.ImpactHammerSkin'
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'
    PutDownSound=Sound'UT3Weapons2.ImpactHammer.A_Weapon_ImpactHammer_Lower01'
}

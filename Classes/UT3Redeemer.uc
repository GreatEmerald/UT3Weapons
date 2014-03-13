//=============================================================================
// UT3Redeemer.uc
// Denied!
// 2008, 2013, 2014 GreatEmerald
//=============================================================================

class UT3Redeemer extends Redeemer;

var Material UDamageOverlay;
var() Sound PutDownSound;

/*
    AttachToPawn mod needed since if you attach it to the right hand, the
    cumbersome thing will clip right through the person's body. Quite
    funny to look at, but not what's intended. -GE
*/

function AttachToPawn(Pawn P)
{
    local name BoneName;

    Instigator = P;
    if ( ThirdPersonActor == None )
    {
        ThirdPersonActor = Spawn(AttachmentClass,Owner);
        InventoryAttachment(ThirdPersonActor).InitFor(self);
    }
    else
        ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
    BoneName = P.GetOffHandBoneFor(self);
    if ( BoneName == '' )
    {
        ThirdPersonActor.SetLocation(P.Location);
        ThirdPersonActor.SetBase(P);
    }
    else
        P.AttachToBone(ThirdPersonActor,BoneName);
}

//GE: cast BringUp and PutDown to the attachment class + put down sound
simulated function BringUp(optional Weapon PrevWeapon)
{
    local int Mode;

    if (UT3RedeemerAttachment(ThirdPersonActor) != None)
        UT3RedeemerAttachment(ThirdPersonActor).BringUp();

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

    if (UT3RedeemerAttachment(ThirdPersonActor) != None)
        UT3RedeemerAttachment(ThirdPersonActor).PutDown();

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

simulated function SetOverlayMaterial(Material mat, float time, bool bOverride)
{
    Super.SetOverlayMaterial(mat, time, bOverride);
    if (OverlayMaterial == class'xPawn'.default.UDamageWeaponMaterial)
        OverlayMaterial = UDamageOverlay;
}

defaultproperties
{
    FireModeClass(0)=UT3RedeemerFire
    FireModeClass(1)=UT3RedeemerGuidedFire
    AttachmentClass=class'UT3RedeemerAttachment'
    ItemName="UT3 Redeemer"
    Description="'Even your least effective soldiers will earn a respectable bodycount with this tactical nuclear device.' So said the original brochure for the Redeemer, still unchallenged in its role as the most powerful man-portable weapon system known through the galaxy.|The slow-moving but utterly devastating missile, affectionately known as 'Lola' by veteran soldiers, now uses an Enhanced Radiation payload. This ensures maximum tissue failure without undue property damage, perfect for modern assault-and-capture tactics.|The Redeemer's alternate mode fires the missile using the disposable fly-by-wire guidance system, though the manual recommends using this mode only in areas of relative safety."
    PickupClass=class'UT3RedeemerPickup'
    SelectSound=Sound'UT3Weapons2.Redeemer.RedeemerTakeOut'
    TransientSoundVolume=0.45
    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=227,Y1=191,X2=299,Y2=233)
    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairRedeemer"
    CustomCrosshairColor=(B=0,G=0,R=255,A=255)
    HudColor=(B=0,G=0,R=255,A=255)
    CustomCrosshairScale=2.0

    IdleAnim="WeaponIdle"
    RestAnim="WeaponIdle"
    AimAnim="WeaponIdle"
    RunAnim="WeaponIdle"
    SelectAnim="WeaponEquip"
    PutDownAnim="WeaponPutDown"
    SelectAnimRate=1.000000
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Redeemer_1P'
    BringUpTime=2.1
    PutDownTime=0.97
    PlayerViewOffset=(X=-8.0,Y=0.0,Z=-16.0)
    SmallViewOffset=(X=-8.0,Y=0.0,Z=-16.0)
    PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
    BobDamping=2.2
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'
    PutDownSound=Sound'UT3Weapons2.Redeemer.A_Weapon_Redeemer_Lower01'
}

/******************************************************************************
UT3LinkGun

Creation date: 2008-07-17 11:16
Last change: 2008-11-01
Copyright (c) 2008, 2013, 2014 Wormbo and GreatEmerald
******************************************************************************/

class UT3LinkGun extends LinkGun;


var Material UDamageOverlay, FallbackSkin;

//=============================================================================
// Imports
//=============================================================================

//#exec obj load file=Sounds/include/UT3LinkGun.uax

simulated function UpdateLinkColor( LinkAttachment.ELinkColor Color ) //GE: Cleaning Skins[] hax.
{
    if ( FireMode[1] != None )
        LinkFire(FireMode[1]).UpdateLinkColor( Color );
}

event ServerStartFire(byte Mode) //GE: Disabling PreFireTime delay.
{
    if ( (Instigator != None) && (Instigator.Weapon != self) )
    {
        if ( Instigator.Weapon == None )
            Instigator.ServerChangedWeapon(None,self);
        else
            Instigator.Weapon.SynchronizeWeapon(self);
        return;
    }

    if ( (FireMode[Mode].NextFireTime <= Level.TimeSeconds)
        && StartFire(Mode) )
    {
        FireMode[Mode].ServerStartFireTime = Level.TimeSeconds;
        FireMode[Mode].bServerDelayStartFire = false;
    }
    else if ( FireMode[Mode].AllowFire() )
    {
        FireMode[Mode].bServerDelayStartFire = true;
    }
    else
        ClientForceAmmoUpdate(Mode, AmmoAmount(Mode));
}

simulated function bool ReadyToFire(int Mode)
{
    local int alt;

    if ( Mode == 0 )
        alt = 1;
    else
        alt = 0;

    if ( ((FireMode[alt] != FireMode[Mode]) && FireMode[alt].bModeExclusive && FireMode[alt].bIsFiring)
        || !FireMode[Mode].AllowFire()
        || (FireMode[Mode].NextFireTime > Level.TimeSeconds) )
    {
        return false;
    }

    return true;
}

simulated function bool StartFire(int Mode)
{
    local int alt;

    if (!ReadyToFire(Mode))
        return false;

    if (Mode == 0)
        alt = 1;
    else
        alt = 0;

    FireMode[Mode].bIsFiring = true;
    FireMode[Mode].NextFireTime = Level.TimeSeconds;

    if (FireMode[alt].bModeExclusive)
    {
        // prevents rapidly alternating fire modes
        FireMode[Mode].NextFireTime = FMax(FireMode[Mode].NextFireTime, FireMode[alt].NextFireTime);
    }

    if (Instigator.IsLocallyControlled())
    {
        if (FireMode[Mode].PreFireTime > 0.0 || FireMode[Mode].bFireOnRelease)
        {
            FireMode[Mode].PlayPreFire();
        }
        FireMode[Mode].FireCount = 0;
    }

    return true;
} //GE: /disable PreFireTime delay

simulated function SetOverlayMaterial(Material mat, float time, bool bOverride)
{
    Super.SetOverlayMaterial(mat, time, bOverride);
    //log(self@"SetOverlayMaterial: mat"@mat@"time"@time@"bOverride"@bOverride);
    if (OverlayMaterial == class'xPawn'.default.UDamageWeaponMaterial)
        OverlayMaterial = UDamageOverlay;
    if (mat == None || time <= 0.0)
    {
        Skins = default.Skins;
    }
    else
        Skins[0] = FallbackSkin;
}





//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    ItemName = "UT3 Link Gun"

    FireModeClass(0) = class'UT3LinkGunFire'
    FireModeClass(1) = class'UT3LinkGunAltFire'

    PickupClass     = class'UT3LinkGunPickup'
    AttachmentClass = class'UT3LinkGunAttachment'

    SelectSound = Sound'LinkGunRaise'
    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairLinkGun"
    CustomCrosshairScale=1.3
    CustomCrosshairColor=(B=0,G=255,R=255,A=255)
    HudColor=(B=0,G=255,R=255,A=255)

    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=226,Y1=233,X2=300,Y2=254)
    Priority=5.000000
    AIRating=0.710000

    IdleAnim="WeaponIdle"
    IdleAnimRate=0.7333
    RestAnim="WeaponIdle"
    RestAnimRate=0.7333
    AimAnim="WeaponIdle"
    AimAnimRate=0.7333
    RunAnim="WeaponIdle"
    RunAnimRate=0.7333
    SelectAnim="WeaponEquip"
    SelectAnimRate=0.7333
    PutDownAnim="WeaponPutDown"
    PutDownAnimRate=0.7333
    OldPlayerViewPivot=(Yaw=49152)
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Linkgun_1P'
    OldMesh=None

    PlayerViewOffset=(X=-11.0,Y=-3.5,Z=2.5)
    SmallViewOffset=(X=4,Y=2,Z=-3)
    PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-16384)
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'
    FallbackSkin=Material'UT3WeaponSkins.T_WP_LinkGun_D'
}

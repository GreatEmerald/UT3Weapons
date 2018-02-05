//==============================================================================
// UT3FlakCannon.uc
// Flak Monkey.
// 2008, 2013, 2014 GreatEmerald
//==============================================================================

class UT3FlakCannon extends FlakCannon;

#exec obj load file=UT3A_Weapon_FlakCannon.uax

var Material UDamageOverlay;
var() Sound PutDownSound;

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
    ItemName="UT3 Flak Cannon"
    Description="Trident Defensive Technologies continues to tweak and refine the flak cannon with their newly released Mk4 'Peacekeeper.' In spite of its new name, the flak cannon remains banned from most military conflicts for high incidences of maiming and collateral damage. Still, the flak cannon is the weapon of choice for unconventional warfare in urban terrain. The primary mode detonates the flak shell in the barrel, launching shrapnel forward in a deadly shotgun pattern but often deafening the operator. The cannon also lobs an explosive flak shell that detonates on contact, sending shrapnel in a dangerously wide and unpredictable radius."
    FireModeClass(0)=UT3FlakFire
    FireModeClass(1)=UT3FlakAltFire
    PickupClass=class'UT3FlakCannonPickup'
    SelectSound=Sound'UT3A_Weapon_FlakCannon.WeaponEquip.EquipCue'
    PutDownSound=Sound'UT3A_Weapon_FlakCannon.WeaponUnEquip.UnEquipCue'
    TransientSoundVolume = 0.8
    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairFlakCannon"
    CustomCrosshairColor=(B=128,G=255,R=255,A=255)
    CustomCrosshairScale=1.5
    HudColor=(B=128,G=255,R=255,A=255)

    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=65,Y1=214,X2=131,Y2=240)

    IdleAnim="WeaponIdle"
    RestAnim="WeaponIdle"
    AimAnim="WeaponIdle"
    RunAnim="WeaponIdle"
    SelectAnim="WeaponEquip"
    PutDownAnim="WeaponPutDown"
    //OldPlayerViewOffset=(Y=7.000000)
    PlayerViewPivot=(Yaw=-250,Pitch=500,Roll=0)
    PlayerViewOffset=(X=-10.0,Y=10.0,Z=-5.0)
    SmallViewOffset=(X=12,Y=20,Z=-13)
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_FlakCannon_1P'
    AttachmentClass=class'UT3FlakAttachment'
    HighDetailOverlay=None
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'
    
}

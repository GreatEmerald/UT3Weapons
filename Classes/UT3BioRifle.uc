//==============================================================================
// UT3BioRifle.uc
// Biohazard!
// 2008, 2013, 2014 GreatEmerald
//==============================================================================

class UT3BioRifle extends BioRifle;

#exec obj load file=UT3A_Weapon_BioRifle.uax

var Material UDamageOverlay;
var() Sound PutDownSound;

simulated function AnimEnd(int Channel)
{
    local name anim;
    local float frame, rate;
    GetAnimParams(0, anim, frame, rate);

    if (anim == 'AltFire')
        LoopAnim('WeaponAltIdle', 1.0, 1.0);
    else
        Super.AnimEnd(Channel);
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
    ItemName="UT3 Bio Rifle"
    Description="The GES BioRifle processes Tarydium from its stable crystalline form into a reactive mutagenic sludge. It can rapidly disperse these toxins for wide-area coverage, or fire a virulent payload of variable, but usually lethal, capacity. In layman's terms, this means the BioRifle can pepper an area with small globs of biosludge, or launch one noxious glob at the target. The BioRifle's ability to carpet an area with a toxic minefield makes it a notoriously effective defensive weapon."

    FireModeClass(0)=UT3BioFire
    FireModeClass(1)=UT3BioChargedFire
    PickupClass=class'UT3BioRiflePickup'
    SelectSound=Sound'UT3A_Weapon_BioRifle.UT3BioRaise.UT3BioRaiseCue'
    PutDownSound=Sound'UT3A_Weapon_BioRifle.UT3BioLower.UT3BioLowerCue'
    TransientSoundVolume=1.0

    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairBioRifle"
    CustomCrosshairColor=(B=64,G=255,R=64,A=255)
    HudColor=(B=64,G=255,R=64,A=255)
    CustomCrosshairScale=1.5

    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=300,Y1=200,X2=363,Y2=229)

    IdleAnim="WeaponIdle"
    RestAnim="WeaponIdle"
    AimAnim="WeaponIdle"
    RunAnim="WeaponIdle"
    SelectAnim="WeaponEquip"
    PutDownAnim="WeaponPutDown"
    SelectAnimRate=1.000000
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_BioRifle_1P'
    IdleAnimRate=0.8
    RestAnimRate=0.8
    RunAnimRate=0.8
    AimAnimRate=0.8

    DrawScale=0.9
    PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
    PlayerViewOffset=(X=4.0,Y=2.0,Z=0.0)
    SmallViewOffset=(X=15,Y=6,Z=-4)

    UV2Mode=UVM_LightMap
    AttachmentClass=class'UT3BioAttachment'
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'
}

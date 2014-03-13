//=============================================================================
// UT3SniperRifle.uc
// Head Hunter.
// 2008, 2013, 2014 GreatEmerald
//=============================================================================

class UT3SniperRifle extends ClassicSniperRifle;

//#EXEC OBJ LOAD FILE=UT3WeaponSounds
var Material HudMaterial;
var Material RedSkin, BlueSkin;

var bool bStopZooming;

var Material UDamageOverlay;
var() Sound PutDownSound;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    FireMode[1].FireAnim = IdleAnim; //GE: I call hax. Double hax, actually.
}

function AttachToPawn(Pawn P)
{
    Super.AttachToPawn(P);
    ApplySkin(); //GE: Applying skin here instead of PostBeginPlay() since we don't have the Instigator nor attachment there yet... We get Instigator on GiveTo, Attachment here.
}

simulated function ApplySkin()
{
    local Controller Contra;
    local UT3SniperAttachment Tach;

    if (Instigator.Controller != None)
        Contra = Instigator.Controller;
    else
        return;

    Tach = UT3SniperAttachment(ThirdPersonActor);
    if ( (Contra != None) && (Contra.PlayerReplicationInfo != None)&& (Contra.PlayerReplicationInfo.Team != None) )
    {
        if ( Contra.PlayerReplicationInfo.Team.TeamIndex == 0 )
        {
            HighDetailOverlay = RedSkin;
            if (Tach != None)
                Tach.HighDetailOverlay = RedSkin;
        }
        else if ( Contra.PlayerReplicationInfo.Team.TeamIndex == 1 )
        {
            HighDetailOverlay = BlueSkin;
            if (Tach != None)
                Tach.HighDetailOverlay = BlueSkin;
        }
        //log("UT3ShockRifle: Tach skin is"@Tach.Skins[0]);
    }
}

simulated event RenderOverlays( Canvas Canvas )
{
    local float ScaleX, ScaleY, StartX;
    local float OldOrgX, OldOrgY, OldClipX, OldClipY;

    if ( PlayerController(Instigator.Controller) == None )
    {
        Super(Weapon).RenderOverlays(Canvas);
        zoomed=false;
        return;
    }

    //if (zoomed=true) PlaySound(Sound'UT3Weapons2.Sniper.SniperZoomIn', SLOT_Interact,,,,,false);

    /*if ( LastFOV > PlayerController(Instigator.Controller).DesiredFOV )
    {
         //HACK: Has to play the full sound! UT3Weapons2.Sniper.SniperZoomIn
    }
    else if ( LastFOV < PlayerController(Instigator.Controller).DesiredFOV )
    {

    } */
    LastFOV = PlayerController(Instigator.Controller).DesiredFOV;

    if ( PlayerController(Instigator.Controller).DesiredFOV == PlayerController(Instigator.Controller).DefaultFOV )
    {
        Super(Weapon).RenderOverlays(Canvas);
        zoomed=false;
    }
    else
    {
        // the sniper overlay is a special case that we want to ignore the safe region
        OldOrgX = Canvas.OrgX;
        OldOrgY = Canvas.OrgY;
        OldClipX = Canvas.ClipX;
        OldClipY = Canvas.ClipY;
        Canvas.OrgX = 0.0;
        Canvas.OrgY = 0.0;
        Canvas.ClipX = Canvas.SizeX;
        Canvas.ClipY = Canvas.SizeY;

        //bDisplayCrosshair = false;

        ScaleY = Canvas.ClipY/768.0;
        ScaleX = ScaleY;
        StartX = 0.5*Canvas.ClipX - 512.0*ScaleX;

        if ( (Instigator == None) || (Instigator.PlayerReplicationInfo == None)
            || (Instigator.PlayerReplicationInfo.Team == None) || (Instigator.PlayerReplicationInfo.Team.TeamIndex == 0) )
        {
            Canvas.SetDrawColor(255,48,0);
        }
        else
        {
            Canvas.SetDrawColor(64,64,255);
        }

        // Draw the crosshair
        // Draw the 4 corners
        Canvas.SetPos(StartX, 0.0);
        Canvas.DrawTile(HudMaterial, 512.0 * ScaleX, 384.0 * ScaleY, 2, 0, 510, 383);

        Canvas.SetPos(Canvas.ClipX*0.5, 0.0);
        Canvas.DrawTile(HudMaterial, 512.0 * ScaleX, 384.0 * ScaleY, 510, 0, -510, 383);

        Canvas.SetPos(StartX, Canvas.ClipY*0.5);
        Canvas.DrawTile(HudMaterial, 512.0 * ScaleX, 384.0 * ScaleY, 2, 383, 510, -383);

        Canvas.SetPos(Canvas.ClipX*0.5, Canvas.ClipY*0.5);
        Canvas.DrawTile(HudMaterial, 512.0 * ScaleX, 384.0 * ScaleY, 510, 383, -510, -383);

        if ( StartX > 0 )
        {
            // Draw the Horizontal Borders
            Canvas.SetPos(0.0, 0.0);
            Canvas.DrawTile(HudMaterial, StartX, 384.0 * ScaleY, 1, 0, 3, 383);

            Canvas.SetPos(Canvas.ClipX - StartX, 0.0);
            Canvas.DrawTile(HudMaterial, StartX, 384.0 * ScaleY, 4, 0, -3, 383);

            Canvas.SetPos(0.0, Canvas.ClipY*0.5);
            Canvas.DrawTile(HudMaterial, StartX, 384.0 * ScaleY, 1, 383, 3, -383);

            Canvas.SetPos(Canvas.ClipX - StartX, Canvas.ClipY*0.5);
            Canvas.DrawTile(HudMaterial, StartX, 384.0 * ScaleY, 4, 383, -3, -383);
        }

        // restore the canvas parameters
        Canvas.OrgX = OldOrgX;
        Canvas.OrgY = OldOrgY;
        Canvas.ClipX = OldClipX;
        Canvas.ClipY = OldClipY;

        zoomed = true;
    }
}

simulated function ClientStartFire(int mode)
{
    if (mode == 1)
    {
        if (zoomed)
            ZoomOut();
        else
            ZoomIn();
    }
    else
    {
        Super(Weapon).ClientStartFire(mode);
    }
}

simulated function ClientStopFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = false;
        bStopZooming = true;
        if (PlayerController(Instigator.Controller) != None && !IsInState('ZoomingIn'))
            PlayerController(Instigator.Controller).StopZoom();
    }
    else
    {
        Super(Weapon).ClientStopFire(mode);
    }
}

simulated function ZoomIn()
{
    bStopZooming = false;
    if ( !IsInState('ZoomingIn') )
        GoToState('ZoomingIn'); //GE: Need latency, thus state
}

simulated function ZoomOut()
{
    FireMode[1].bIsFiring = true;
    if( Instigator.Controller.IsA( 'PlayerController' ) )
        PlayerController(Instigator.Controller).ToggleZoom();
    PlaySound(Sound'UT3Weapons2.Sniper.SniperZoomOut', SLOT_Interact,,,,,false);
    PlayAnim('WeaponZoomOut');
}

simulated state ZoomingIn
{
Begin:
    PlaySound(Sound'UT3Weapons2.Sniper.SniperZoomIn', SLOT_Interact,,,,,false);
    PlayAnim('WeaponZoomIn', 2.666);
    Sleep(0.2);
    FireMode[1].bIsFiring = true;
    if (Instigator.Controller.IsA('PlayerController') )
    {
        PlayerController(Instigator.Controller).StartZoom();
        Sleep(0.05); // GEm: Needs at least a few ticks to start zooming...
        if (bStopZooming)
            PlayerController(Instigator.Controller).StopZoom();
    }
    GoToState('');
}

simulated function bool WantsZoomFade()
{
    return false;
}

/*
 * GE: Obligary functions follow (since we don't have our own weapon parent class)
 */

simulated function vector GetEffectStart()
{
    local Coords C;

    // jjs - this function should actually never be called in third person views
    // any effect that needs a 3rdp weapon offset should figure it out itself

    //GE: Revert to maths if the player has no bones to attach to
    if (Instigator.Controller.Handedness == 2.0)
        return Super.GetEffectStart();

    // 1st person
    if (Instigator.IsFirstPerson())
    {
        C = GetBoneCoords('tip');
        return C.Origin;
    }
    // 3rd person
    else
    {
        return (Instigator.Location +
            Instigator.EyeHeight*Vect(0,0,0.5) +
            Vector(Instigator.Rotation) * 40.0);
    }
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
    ItemName="UT3 Sniper Rifle"
    Description="The venerable Axon Research long-range target interdiction rifle is the weapon of choice for the discerning sniper. Acquisition of a target at distance requires a steady hand, but the rewards merit the effort: the high-caliber round is lethal at any range. With a precise headshot, the target will be neutralized by the super-sonic bullet long before they hear the report. As they say in the N.E.G. Marines: 'any shot you hear is nothing to be worried about.'"

    FireModeClass(0)=UT3SniperFire

    PickupClass=class'UT3SniperRiflePickup'
    AttachmentClass=class'UT3SniperAttachment'
    SelectSound=Sound'UT3Weapons2.Sniper.SniperTakeOut'
    TransientSoundVolume=0.73

    bSniping=true
    AIRating=0.700000
    CurrentRating=0.700000

    Priority=4.100000

    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairSniperRifle"
    CustomCrosshairColor=(B=64,G=0,R=255,A=255)
    CustomCrosshairScale=1.0
    HudColor=(B=64,G=0,R=255,A=255)
    HUDMaterial=Texture'UT3WeaponSkins.SniperRifle.T_SniperCrosshair'
    HighDetailOverlay=Shader'UT3WeaponSkins.SniperRifle.SniperRifleSkinRed'
    Skins(0)=Texture'UT3WeaponSkins.SniperRifle.T_WP_SniperRifle_D' //GE: The skin must not be a combiner or it gets the "ghost" effect
    RedSkin=Shader'UT3WeaponSkins.SniperRifle.SniperRifleSkinRed'
    BlueSkin=Shader'UT3WeaponSkins.SniperRifle.SniperRifleSkinBlue'

    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=362,Y1=260,X2=445,Y2=286)

    IdleAnim="WeaponIdle"
    RestAnim="WeaponIdle"
    AimAnim="WeaponIdle"
    RunAnim="WeaponIdle"
    SelectAnim="WeaponEquip"
    PutDownAnim="WeaponPutDown"
    //OldPlayerViewPivot=(Yaw=49152)
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_SniperRifle_1P'
    DrawScale=1.000000
    PlayerViewPivot=(Pitch=0,Yaw=0,Roll=0)
    PlayerViewOffset=(X=7.0,Y=0.0,Z=0.0)
    SmallViewOffset=(X=37,Y=10,Z=-10)
    BobDamping=1.0
    BringUpTime=0.533
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'
    PutDownSound=Sound'UT3Weapons2.Sniper.A_Weapon_Sniper_Lower01'
}

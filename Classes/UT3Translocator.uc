/******************************************************************************
UT3Translocator

Creation date: 2008-07-08 12:25
Latest change: $Id$
Copyright (c) 2008, 2013, 2014 Wormbo, GreatEmerald
******************************************************************************/

class UT3Translocator extends TransLauncher;


//=============================================================================
// Imports
//=============================================================================

//#exec obj load file=Sounds/include/UT3Translocator.uax

var Material RedSkin, BlueSkin, RedEffect, BlueEffect;
var name EmptyBringUpAnim, IdleAnimEmpty, PutDownEmptyAnim; //GE: Woah, chaotic, isn't it?
var vector ModuleLocation; //GE: Used for determining which recall animation to play. If set, no guarantees that transbeacon exists

function ReduceAmmo()
{
	Super.ReduceAmmo();
	// reset ammo regeneration progress
	AmmoChargeF = RepAmmo;
}

simulated event RenderOverlays( Canvas Canvas )
{
    local float tileScaleX, tileScaleY, dist, clr;
    local float NewTranslocScale;

    if ( (PlayerController(Instigator.Controller) != None) && (PlayerController(Instigator.Controller).ViewTarget == TransBeacon) )
    {
        tileScaleX = Canvas.SizeX / 640.0f;
        tileScaleY = Canvas.SizeY / 480.0f;

        Canvas.DrawColor.R = 255;
        Canvas.DrawColor.G = 255;
        Canvas.DrawColor.B = 255;
        Canvas.DrawColor.A = 255;

        Canvas.Style = 255;
        Canvas.SetPos(0,0);
        Canvas.DrawTile( Material'TransCamFB', Canvas.SizeX, Canvas.SizeY, 0.0, 0.0, 512, 512 ); // !! hardcoded size
        Canvas.SetPos(0,0);

        if ( !Level.IsSoftwareRendering() )
        {
            dist = VSize(TransBeacon.Location - Instigator.Location);
            if ( dist > MaxCamDist )
            {
                clr = 255.0;
            }
            else
            {
                clr = (dist / MaxCamDist);
                clr *= 255.0;
            }
            clr = Clamp( clr, 20.0, 255.0 );
            Canvas.DrawColor.R = clr;
            Canvas.DrawColor.G = clr;
            Canvas.DrawColor.B = clr;
            Canvas.DrawColor.A = 255;
            Canvas.DrawTile( Material'ScreenNoiseFB', Canvas.SizeX, Canvas.SizeY, 0.0, 0.0, 512, 512 ); // !! hardcoded size
        }
    }
    else
    {
        if ( TransBeacon == None )
            NewTranslocScale = 1;
        else
            NewTranslocScale = 0;

        if ( NewTranslocScale != TranslocScale )
        {
            TranslocScale = NewTranslocScale;
            SetBoneScale(0,TranslocScale,'Beacon');
        }
        if ( TranslocScale != 0 )
        {
            TranslocRot.Yaw += 120000 * (Level.TimeSeconds - OldTime);
            OldTime = Level.TimeSeconds;
            SetBoneRotation('Beacon',TranslocRot,0);
        }
        if ( !bTeamSet && (Instigator.PlayerReplicationInfo != None) && (Instigator.PlayerReplicationInfo.Team != None) )
        {
            bTeamSet = true;
            if ( Instigator.PlayerReplicationInfo.Team.TeamIndex == 1 )
            {
                Skins[0] = BlueEffect;
                Skins[1] = BlueSkin; //GE: And why don't they like global vars so much?
            }
        }
        Super.RenderOverlays(Canvas);
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    if (TransBeacon != None)
        SelectAnim = EmptyBringUpAnim;
    else
        SelectAnim = default.SelectAnim;
    Super.BringUp(PrevWeapon);
}

simulated function bool PutDown()
{
    if (TransBeacon != None)
        PutDownAnim = PutDownEmptyAnim;
    else
        PutDownAnim = default.PutDownAnim;
    return Super.PutDown();
}

simulated event WeaponTick( float dt )
{
    if (Transbeacon != None && TransBeacon.Physics != PHYS_None) //GE: If the beacon is flying (don't bother updating if it's standing)
    {
        ModuleLocation = TransBeacon.Location;
    }
    if (Transbeacon != None && !bBeaconDeployed)            //GE: If the beacon is deployed and we didn't know that the beacon is deployed
    {
        bBeaconDeployed = True;     //GE: Now we know
        if (!FireMode[0].bIsFiring) //GE: And if we're currently not firing
            PlayIdle();             //GE: refresh the idle anim
    }
    else if (Transbeacon == None && bBeaconDeployed)                               //GE: If the beacon isn't deployed and we don't know that
    {
        bBeaconDeployed = False;    //GE: Now we know
        if (!FireMode[0].bIsFiring) //GE: And if we're currently not firing
            PlayIdle();             //GE: refresh the idle anim
    }
    Super.WeaponTick(dt);
}

simulated function PlayIdle()
{
    if (TransBeacon == None)
        LoopAnim(IdleAnim, IdleAnimRate, 0.0);
    else
        LoopAnim(IdleAnimEmpty, IdleAnimRate, 0.0);
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	ItemName    = "UT3 Translocator"
	Description = "The Translocator was originally designed by Liandri R&D for rapid rescue of expensive mining equipment during tunnel collapses and related emergencies. The technology also saved couintless lives, but not without a cost: rapid deresolution and reconstitution led to synaptic disruptions, and the debilitating symptoms like Teleportation Related Dementia (TReDs).||Today, after years of lucrative military development contracts, portable teleportation technology has been declared 'sufficiently safe' for regular use by frontline infantry."

	FireModeClass[0] = class'UT3TranslocatorFire'
	FireModeClass[1] = class'UT3TranslocatorActivate'
	AttachmentClass = class'UT3TranslocatorAttachment'

	SelectSound = Sound'TranslocatorRaise'
	TransientSoundVolume = 0.7
	TransientSoundRadius = 1000.0

	// higher capacity and recharge rate
	AmmoChargeF    = 7.0
	RepAmmo        = 7
	AmmoChargeMax  = 7.0
	AmmoChargeRate = 0.8

	CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairDefault"
	CustomCrosshairColor=(B=128,G=255,R=255,A=255)
	CustomCrosshairScale=1.2
	HudColor=(B=128,G=255,R=255,A=255)

	IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=300,Y1=230,X2=361,Y2=256)

     IdleAnim="WeaponIdle"
     IdleAnimEmpty="WeaponIdleEmpty"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     EmptyBringUpAnim="WeaponEquipEmpty"
     PutDownAnim="WeaponPutDown"
     PutDownEmptyAnim="WeaponPutDownEmpty"
     Priority=0
     CustomCrosshair=19
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Translocator_1P'
     DrawScale = 1.0
     PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
     PlayerViewOffset=(X=-3.0,Y=0.3,Z=-0.3)
     SmallViewOffset=(X=5.0,Y=4.0,Z=-4.0)
     BringUpTime=0.4667

     RedSkin=Material'UT3WeaponSkins.Translocator.TranslocatorSkinRed'
     BlueSkin=Material'UT3WeaponSkins.Translocator.TranslocatorSkinBlue'
     RedEffect=Material'UT3WeaponSkins.Translocator.FbElec2'
     BlueEffect=Material'UT3WeaponSkins.Translocator.FbElec1'

     Skins(0)=Material'UT3WeaponSkins.Translocator.FbElec2'
     Skins(1)=Material'UT3WeaponSkins.Translocator.TranslocatorSkinRed'
}

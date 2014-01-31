//=============================================================================
// UT3Minigun2v.uc
// It was supposed to be UT3Minigunv2, but they won't like classes ending in a digit :(
// 2008, 2013, 2014 GreatEmerald
//=============================================================================
class UT3Minigun2v extends Weapon
    config(user);

#EXEC OBJ LOAD FILE=InterfaceContent.utx

var     float           CurrentRoll;
var     float           RollSpeed;
//var     float           FireTime;
var() xEmitter          ShellCaseEmitter;
var() vector            AttachLoc;
var() rotator           AttachRot;
var   int               CurrentMode;
var() float             GearRatio;
var() float             GearOffset;
var() float             Blend;

var Material UDamageOverlay;

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

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if ( Level.NetMode == NM_DedicatedServer )
        return;

    ShellCaseEmitter = spawn(class'ShellSpewer');
	if ( ShellCaseEmitter != None )
	{
		ShellCaseEmitter.Trigger(Self, Instigator); //turn off
		AttachToBone(ShellCaseEmitter, 'shell');
	}
}

/*function DropFrom(vector StartLocation)
{
	Super.DropFrom(StartLocation);
} */

simulated function OutOfAmmo()
{
    if ( (Instigator == None) || !Instigator.IsLocallyControlled() || HasAmmo() )
        return;

	Instigator.AmbientSound = None;
	Instigator.SoundVolume = Instigator.default.SoundVolume;
    DoAutoSwitch();
}

simulated function Destroyed()
{
    if (ShellCaseEmitter != None)
    {
        ShellCaseEmitter.Destroy();
        ShellCaseEmitter = None;
    }

    Super.Destroyed();
}

function float GetAIRating()
{
    local Bot B;

    B = Bot(Instigator.Controller);
    if ( (B== None) || (B.Enemy == None) )
        return AIRating;

    if ( !B.EnemyVisible() )
        return AIRating - 0.15;

    return AIRating * FMin(Pawn(Owner).DamageScaling, 1.5);
}

function byte BestMode()
{
    local float EnemyDist;
    local Bot B;

    if ( IsFiring() )
        return BotMode;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return 0;

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if ( EnemyDist < 2000 )
        return 1;
    return 0;
}

simulated function SpawnShells(float amountPerSec)
{
    if(ShellCaseEmitter == None || !FirstPersonView())
        return;
	if ( Bot(Instigator.Controller) != None )
	{
		ShellCaseEmitter.Destroy();
		return;
	}

	ShellCaseEmitter.mRegenRange[0] = amountPerSec;
	ShellCaseEmitter.mRegenRange[1] = amountPerSec;
    ShellCaseEmitter.Trigger(self, Instigator);
}

simulated function bool FirstPersonView()
{
    return (Instigator.IsLocallyControlled() && (PlayerController(Instigator.Controller) != None) && !PlayerController(Instigator.Controller).bBehindView);
}

simulated function UpdateRoll(float dt, float speed, int mode)
{
    return; //GE: No longer script-controlled.
}

simulated function bool StartFire(int mode)
{
    local bool bStart;

    bStart = Super.StartFire(mode);
    if (bStart)
        FireMode[mode].StartFiring();

    return bStart;
}

// Allow fire modes to return to idle on weapon switch (server)
simulated function DetachFromPawn(Pawn P)
{
    ReturnToIdle();
    Super.DetachFromPawn(P);
}

// Allow fire modes to return to idle on weapon switch (client)
simulated function bool PutDown()
{
    ReturnToIdle();

    return Super.PutDown();
}

simulated function SetOverlayMaterial(Material mat, float time, bool bOverride)
{
    Super.SetOverlayMaterial(mat, time, bOverride);
    if (OverlayMaterial == class'xPawn'.default.UDamageWeaponMaterial)
        OverlayMaterial = UDamageOverlay;
}

simulated function ReturnToIdle();

simulated function PlayIdle()
{
    LoopAnim(IdleAnim, IdleAnimRate, 0.0);
}

defaultproperties
{
    //AttachLoc=(X=-77.000000,Y=6.000000,Z=4.000000)
    AttachRot=(Pitch=22000,Yaw=-16384)
    GearRatio=-2.370000
    Blend=1.000000
    IdleAnim="WeaponIdle"
    RestAnim="WeaoponIdle"
    AimAnim="WeaponIdle"
    RunAnim="WeaponIdle"
    SelectAnim="WeaponEquip"
    PutDownAnim="WeaponPutDown"
    SelectForce="SwitchToMiniGun"

    IdleAnimRate=0.7333
    RestAnimRate=0.7333
    AimAnimRate=0.7333
    RunAnimRate=0.7333
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    BringUpTime=1.16
    PutDownTime=0.76

    CurrentRating=0.710000
    Priority=6.000000
    AIRating=0.710000

    //EffectOffset=(X=100.000000,Y=18.000000,Z=-16.000000)
    DisplayFOV=60.000000
    PlayerViewOffset=(X=1.0,Y=-0.5,Z=0.5)
    SmallViewOffset=(X=6.0,Y=1.3,Z=-1.3)
    PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
    //CenteredOffsetY=-6.000000
    //CenteredRoll=0
    //CenteredYaw=-500
    InventoryGroup=6
    //PlayerViewOffset=(X=2.000000,Y=-1.000000)
    //PlayerViewPivot=(Yaw=500)
    BobDamping=2.250000
    AttachmentClass=class'UT3MinigunAttachment'
    bDynamicLight=false
    LightType=LT_Pulse
    LightEffect=LE_NonIncidence
    LightPeriod=3
    LightBrightness=255
    LightHue=30
    LightSaturation=150
    LightRadius=5.0
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Stinger_1P'
    DrawScale=0.400000
    SoundRadius=400.000000
    //HighDetailOverlay=Combiner'UT2004Weapons.WeaponSpecMap2'
    UDamageOverlay=Material'UT3Pickups.Udamage.M_UDamage_Overlay_S'

    ItemName="UT3 Stinger Minigun"
    Description="Replacing the Minigun in this year's Tournament, the 'Stinger' is actually a Liandri mining tool converted into military service.|The Stinger fires shards of unprocessed Tarydium crystal at an alarming rate, raking opponents with a storm of deadly needles. The alternate fire shoots larger hunks of crystal that can knock back an opponent, sometimes even pinning them to walls."

    FireModeClass(0)=UT3MinigunFire
    FireModeClass(1)=UT3MinigunAltFire
    PickupClass=class'UT3MinigunPickup'
    SelectSound=Sound'UT3Weapons2.Stinger.StingerTakeOut'

    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairStinger"
    CustomCrosshairColor=(B=0,G=255,R=255,A=255)
    CustomCrosshairScale=1.5
    HudColor=(B=0,G=255,R=255,A=255)

    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=227,Y1=254,X2=299,Y2=279)
}

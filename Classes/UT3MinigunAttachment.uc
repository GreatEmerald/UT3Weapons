//==============================================================================
// UT3MinigunAttachment.uc
// This small thing stings.
// 2010, GreatEmerald
//==============================================================================

class UT3MinigunAttachment extends xWeaponAttachment;

var class<Emitter>      mMuzFlashClass;
var Emitter             mMuzFlash3rd;

var class<xEmitter>     mShellCaseEmitterClass;
var xEmitter            mShellCaseEmitter;
var() vector            mShellEmitterOffset;
var vector  mOldHitLocation;
var byte                OldSpawnHitCount;
var() name FireAnim;
var() name AltFireAnim;
var() float FireAnimRate;
var() float AltFireAnimRate;
var() float TweenTime;

function Destroyed()
{
    if (mMuzFlash3rd != None)
        mMuzFlash3rd.Destroy();

    if (mShellCaseEmitter != None)
        mShellCaseEmitter.Destroy();

    Super.Destroyed();
}

simulated event ThirdPersonEffects() //GE: Backported MinigunAttachment's shell emitter, also handles animations
{
    local PlayerController PC;
    
    if ( (Level.NetMode == NM_DedicatedServer) || (Instigator == None) )
        return; 

    if ( FlashCount > 0 )
    {
        PC = Level.GetLocalPlayerController();
        if ( OldSpawnHitCount != SpawnHitCount )
        {
            OldSpawnHitCount = SpawnHitCount;
            GetHitInfo();
            PC = Level.GetLocalPlayerController();
            if ( (Instigator.Controller == PC) || (VSize(PC.ViewTarget.Location - mHitLocation) < 2000) )
            {
                if ( FiringMode == 0 )
                {
                    Spawn(class'HitEffect'.static.GetHitEffect(mHitActor, mHitLocation, mHitNormal),,, mHitLocation, Rotator(mHitNormal));
                    //log("UT3MinigunAttachment.ThirdPersonEffects: spawned"@class'HitEffect'.static.GetHitEffect(mHitActor, mHitLocation, mHitNormal));
                }
                
                CheckForSplash();
            }
        }
        if ( (Level.TimeSeconds - LastRenderTime > 0.2) && (Instigator.Controller != PC) )
            return;
            
        if (FiringMode == 0 && !IsAnimating())
            LoopAnim(FireAnim, FireAnimRate, TweenTime);
        else if (FiringMode == 1)
            PlayAnim(AltFireAnim, AltFireAnimRate, TweenTime);

        WeaponLight();

        if (mMuzFlash3rd == None)
        {
            mMuzFlash3rd = Spawn(mMuzFlashClass);
            AttachToBone(mMuzFlash3rd, 'tip');
        }
        if (mMuzFlash3rd != None)
        {
            mMuzFlash3rd.SpawnParticle(1);
        }

        if ( (mShellCaseEmitter == None) && (Level.DetailMode != DM_Low) && !Level.bDropDetail )
        {
            mShellCaseEmitter = Spawn(mShellCaseEmitterClass);
            if ( mShellCaseEmitter != None )
                AttachToBone(mShellCaseEmitter, 'shell');
        }
        if (mShellCaseEmitter != None)
            mShellCaseEmitter.mStartParticles++;
    }
    else if (FiringMode == 0 && IsAnimating())
    {
        AnimStopLooping();
    }

    Super.ThirdPersonEffects();
}

/* UpdateHit
- used to update properties so hit effect can be spawn client side
*/
function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
    NetUpdateTime = Level.TimeSeconds - 1;
    SpawnHitCount++;
    mHitLocation = HitLocation;
    mHitActor = HitActor;
    mHitNormal = HitNormal;
}


defaultproperties
{
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Stinger_3P_Mid'
     DrawScale=0.9
     RelativeRotation=(Pitch=32768,Yaw=16384)
     RelativeLocation=(X=0,Y=-2,Z=2)
     mShellCaseEmitterClass=Class'XEffects.ShellSpewer'
     mMuzFlashClass=Class'XEffects.NewMinigunMFlash'
     bHeavy=True
     bRapidFire=True
     bAltRapidFire=False
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     CullDistance=5000.000000
     FireAnim="WeaponFire"
     AltFireAnim="WeaponAltFire"
     FireAnimRate=1.0
     AltFireAnimRate=1.0
     TweenTime=0.0

}
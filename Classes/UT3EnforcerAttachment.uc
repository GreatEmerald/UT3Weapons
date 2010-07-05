//==============================================================================
// UT3EnforcerAttachment.uc
// Whatever you have attached enforces you to kill.
// 2010, GreatEmerald
//==============================================================================

class UT3EnforcerAttachment extends AssaultAttachment;

simulated event ThirdPersonEffects()
{
    local PlayerController PC;
    //local rotator r;
    
    if ( Level.NetMode != NM_DedicatedServer )
    {
        AimAlpha = 1;
        if ( TwinGun != None )
            TwinGun.AimAlpha = 1;
        //if (FiringMode == 0)
        //{
            WeaponLight();
            if ( OldSpawnHitCount != SpawnHitCount )
            {
                OldSpawnHitCount = SpawnHitCount;
                GetHitInfo();
                PC = Level.GetLocalPlayerController();
                if ( ((Instigator != None) && (Instigator.Controller == PC)) || (VSize(PC.ViewTarget.Location - mHitLocation) < 4000) )
                {
                    Spawn(class'HitEffect'.static.GetHitEffect(mHitActor, mHitLocation, mHitNormal),,, mHitLocation, Rotator(mHitNormal));
                    CheckForSplash();
                }
            }
            MakeMuzzleFlash();
            if ( !bDualGun && (TwinGun != None) )
                TwinGun.MakeMuzzleFlash(); 
        //}
       /* else if (FiringMode == 1 && FlashCount > 0)
        {
            WeaponLight();
            if (mMuzFlash3rdAlt == None)
            {    
                mMuzFlash3rdAlt = Spawn(mMuzFlashClass);
                AttachToBone(mMuzFlash3rdAlt, 'tip');
                //r=mMuzFlash3rdAlt.Rotation;
                //r.Roll += 16384;
                //log("UT3Style.UT3EnforcerAttachment: Muzzle Flash Rotation before:"@mMuzFlash3rdAlt.Rotation);
                //mMuzFlash3rdAlt.SetRotation(r);
                //log("UT3Style.UT3EnforcerAttachment: Muzzle Flash Rotation after:"@mMuzFlash3rdAlt.Rotation);
            }
            mMuzFlash3rdAlt.mStartParticles++;   
        } */
    }

    Super(xWeaponAttachment).ThirdPersonEffects();
}


/*simulated function MakeMuzzleFlash()
{
    AimAlpha = 1;
    if ( TwinGun != None )
        TwinGun.AimAlpha = 1;
    if (mMuzFlash3rd == None)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, 'tip');
    }
    mMuzFlash3rd.mStartParticles++;
}*/

defaultproperties
{
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Enforcers_1P'
     RelativeLocation=(X=55.000000,Y=-23.000000,Z=-30.000000)
     DrawScale=0.150000
}

//==============================================================================
// UT3EnforcerEffect.uc
// Currently, a temporary effect that looks like a tracer. Needs UT3 texture.
// 2010, GreatEmerald
//==============================================================================

class UT3EnforcerEffect extends ShockBeamEffect;

/*var class<xEmitter> UnlockedMuzFlash3Class;
var class<xEmitter> UnlockedMuzFlashClass;
var name WeaponMuzFlashBone, AttachmentMuzFlashBone; */

simulated function SpawnEffects()
{
    //local ShockBeamCoil Coil;
    local xWeaponAttachment Attachment;
    //local xEmitter FlashEmitter, FlashEmitter2;
    
    if (Instigator != None)
    {
        if ( Instigator.IsFirstPerson() )
        {
            if ( (Instigator.Weapon != None) && (Instigator.Weapon.Instigator == Instigator) )
                SetLocation(Instigator.Weapon.GetEffectStart());
            else
                SetLocation(Instigator.Location); 
          /*  FlashEmitter = Spawn(UnlockedMuzFlashClass,,, Location);
            if (FlashEmitter != None && Instigator.Weapon != None )
            {
              Instigator.Weapon.AttachToBone(FlashEmitter, WeaponMuzFlashBone);
              FlashEmitter.mStartParticles++;//log("UT3Style: UT3EnforcerEffect - Log Emitter exists! Rotation:"@LogEmitter.Rotation);
            }  */
            
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1)
            {
                SetLocation(Attachment.GetTipLocation());
            //    Attachment.WeaponLight();
            }
            else
                SetLocation(Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Normal(mSpawnVecA - Instigator.Location) * 25.0); 
           /* FlashEmitter2 = Spawn(UnlockedMuzFlash3Class);
            if (FlashEmitter2 != None )
            {
              Attachment.AttachToBone(FlashEmitter2, AttachmentMuzFlashBone);
              FlashEmitter2.mStartParticles++;//log("UT3Style: UT3EnforcerEffect - Log Emitter2 exists! Rotation:"@LogEmitter2.Rotation);
            } */
        }
    }

    /*if ( EffectIsRelevant(mSpawnVecA + HitNormal*2,false) && (HitNormal != Vect(0,0,0)) )
        SpawnImpactEffects(Rotator(HitNormal),mSpawnVecA + HitNormal*2);
    
    if ( (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (VSize(Location - mSpawnVecA) > 40) && !Level.GetLocalPlayerController().BeyondViewDistance(Location,0))
        || ((Instigator != None) && Instigator.IsFirstPerson()) )
    {
        Coil = Spawn(CoilClass,,, Location, Rotation);
        if (Coil != None)
            Coil.mSpawnVecA = mSpawnVecA;
    } */
}

defaultproperties
{
     mSizeRange(0)=3.000000
     mSizeRange(1)=6.000000
     mLifeRange(0)=0.250000
     LifeSpan=0.250000
     //UnlockedMuzFlash3Class=class'XEffects.AssaultMuzFlash3rd'
     //UnlockedMuzFlashClass=class'XEffects.AssaultMuzFlash1st'
    // WeaponMuzFlashBone='FwdReceiver'
     //AttachmentMuzFlashBone='FwdReceiver'
}
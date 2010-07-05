//==============================================================================
// UT3BioAttachment.uc
// No, not THAT kind of attachment!
// 2010, GreatEmerald
//==============================================================================

class UT3BioAttachment extends BioAttachment;

simulated event ThirdPersonEffects()
{
    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
    {
        if (MuzFlash3rd == None)
        {
            //log("UT3BioAttachment: MuzFlash3rd is none");
            MuzFlash3rd = Spawn(class'XEffects.BioMuzFlash1st');
            MuzFlash3rd.bHidden = false;
            AttachToBone(MuzFlash3rd, 'FrontAssemblyRotate'); //GE: Originally "tip" - but that does NOT exist?!
            //log("UT3BioAttachment: MuzFlash3rd is"@MuzFlash3rd);
        }
        if (MuzFlash3rd != None)
        {
           /* R.Roll = Rand(65536);    //We don't have dummy bones.
            SetBoneRotation('FrontAssemblyRotate', R, 0, 1.0); */
            MuzFlash3rd.mStartParticles++;
        }
    }

    Super(xWeaponAttachment).ThirdPersonEffects();
}

defaultproperties
{
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_BioRifle_1P'
     RelativeLocation=(X=90.000000,Y=-35.000000,Z=-48.000000)
     RelativeRotation=(Pitch=32768)
     DrawScale=0.900000
}

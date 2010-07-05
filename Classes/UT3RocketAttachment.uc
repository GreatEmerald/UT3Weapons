//==============================================================================
// RocketAttachment.uc
// Ridin' the rockets.
// 2010, GreatEmerald
//==============================================================================

class UT3RocketAttachment extends RocketAttachment;

//GE: Note that the animation of alt fire is handled in the RocketMultiFire class.

simulated event ThirdPersonEffects()
{
    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
    {
        if (MuzFlash == None)
        {
            MuzFlash = Spawn(MuzFlashClass);
            if ( MuzFlash != None )
                AttachToBone(MuzFlash, 'tip');
        }
        if (MuzFlash != None)
            MuzFlash.mStartParticles++;
    }

    Super(xWeaponAttachment).ThirdPersonEffects();
}

defaultproperties
{
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_RocketLauncher_3P'
     RelativeLocation=(Y=-2.000000,Z=1.000000)
     RelativeRotation=(Pitch=32768,Yaw=16384)
     DrawScale=1.000000
}

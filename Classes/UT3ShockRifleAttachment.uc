//==============================================================================
// UT3ShockRifleAttachment.uc
// Ridin' the shockwave.
// 2010, GreatEmerald
//==============================================================================

class UT3ShockRifleAttachment extends ShockAttachment;

var Material RedSkin, BlueSkin;

simulated function PostNetBeginPlay()
{
    Super(xWeaponAttachment).PostNetBeginPlay();    
    /*if ( (Instigator != None) && (Instigator.PlayerReplicationInfo != None)&& (Instigator.PlayerReplicationInfo.Team != None) )
    {
        if ( Instigator.PlayerReplicationInfo.Team.TeamIndex == 0 )
            Skins[0] = RedSkin;
        else if ( Instigator.PlayerReplicationInfo.Team.TeamIndex == 1 )
            Skins[0] = BlueSkin;
    }*/
}

/*simulated event ThirdPersonEffects()
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
} */

defaultproperties
{
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_ShockRifle_3P'
     RelativeLocation=(X=0.000000,Y=-2.000000,Z=1.000000)
     RelativeRotation=(Yaw=16384)
     DrawScale=0.900000
     Skins(0)=Shader'UT3WeaponSkins.ShockRifle.ShockRifleSkin'
     Skins(1)=None
}

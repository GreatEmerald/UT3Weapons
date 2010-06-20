//==============================================================================
// UT3AVRiLAttachment.uc
// I think that Avril is getting pretty attached to you.
// 2010, GreatEmerald
//==============================================================================

class UT3AVRiLAttachment extends ONSAVRiLAttachment;

var name FireAnim;
var float FireAnimRate, TweenTime;

simulated event ThirdPersonEffects()
{
    // have pawn play firing anim
    if ( Instigator != None ) 
    {
        if ( FiringMode != 1 ) //GE: Disable pawn animation on alt fire
            Instigator.PlayFiring(1.0,'0');
    }
}

simulated function PlayFiring()
{
    PlayAnim(FireAnim, FireAnimRate, TweenTime);
}

defaultproperties
{
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Avril_3P_Mid'     
     RelativeLocation=(X=0,Y=-2,Z=1)
     RelativeRotation=(Pitch=32768,Yaw=16384)
     DrawScale=0.9
     FireAnim="WeaponReload"
     FireAnimRate=0.5
     TweenTime=0.1
}
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
     FireAnim="weaponreload"
     FireAnimRate=0.500000
     TweenTime=0.100000
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Avril_3P_Mid'
     RelativeLocation=(X=0.000000,Y=-2.000000,Z=1.000000)
     RelativeRotation=(Pitch=32768,Yaw=16384)
     DrawScale=0.900000
}

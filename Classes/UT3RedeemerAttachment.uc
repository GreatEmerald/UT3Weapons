//==============================================================================
// UT3RedeemerAttachment.uc
// Now that's heavy.
// 2010, GreatEmerald
//==============================================================================

class UT3RedeemerAttachment extends RedeemerAttachment;

var float AimAlpha;
var name SelectAnim, PutDownAnim;
var float SelectAnimRate, PutDownAnimRate;

simulated function Destroyed() //GE: cleared dead code.
{
    if ( Instigator != None )
    {
        Instigator.SetBoneDirection(AttachmentBone, Rotation,, 0, 0);
        Instigator.SetBoneDirection('lfarm', Rotation,, 0, 0);
    }
    Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
    Super(xWeaponAttachment).ThirdPersonEffects();
}

simulated function Tick(float deltatime) //GE: pointing the right direction
{
    local rotator newRot;

    if ( Level.NetMode == NM_DedicatedServer )
    {
        Disable('Tick');
        return;
    }
    
    AimAlpha = AimAlpha * ( 1 - 2*DeltaTime);
        
    // point in firing direction
    if ( Instigator != None )
    {
        newRot = Instigator.Rotation;
        if ( AimAlpha < 0.5 )
            newRot.Yaw += 4500 * (1 - 2*AimAlpha);
        Instigator.SetBoneDirection('lfarm', newRot,, 1.0, 1);
        
        newRot.Roll += 32768;
        Instigator.SetBoneDirection(AttachmentBone, newRot,, 1.0, 1);
    }
}

function BringUp()
{
    if ( (Mesh!=None) && HasAnim(SelectAnim) )
        PlayAnim(SelectAnim, SelectAnimRate, 0.0);
}

function PutDown()
{
    if ( (Mesh!=None) && HasAnim(PutDownAnim) )
        PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
}

defaultproperties
{
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Redeemer_3P_Mid'
     RelativeLocation=(X=20,Y=-35,Z=-5)
     RelativeRotation=(Yaw=21000)
     DrawScale=0.9
     SelectAnim="WeaponEquip"
     SelectAnimRate=1.0
     PutDownAnim="WeaponPutDown"
     PutDownAnimRate=1.0

}
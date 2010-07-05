//=============================================================================
// UT3ImpactHammerAttachment.uc
// I'll have to implement the charged animation...
// GreatEmerald, 2010
//=============================================================================
class UT3ImpactHammerAttachment extends ShieldAttachment;

var class<ForceRing> FlashEmitter, FlashEmitterAlt;
var ForceRing ForceRing3rdAlt;

simulated event ThirdPersonEffects()
{
    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
    {
        if ( FiringMode == 0 )
        {
            if (ForceRing3rd == None)
            {
                ForceRing3rd = Spawn(FlashEmitter);
                AttachToBone(ForceRing3rd, 'tip');
            }

            ForceRing3rd.Fire();
        }
        if ( FiringMode == 1 )
        {
            if (ForceRing3rdAlt == None)
            {
                ForceRing3rdAlt = Spawn(FlashEmitterAlt);
                AttachToBone(ForceRing3rdAlt, 'tip');
            }

            ForceRing3rdAlt.Fire();
        }
        StopCharging();
    }
    
    Super.ThirdPersonEffects();
}

function PlayCharged()
{
    LoopAnim('WeaponChargedIdle');
}

function StopCharging()
{
    LoopAnim('WeaponIdle');
}

defaultproperties
{
     FlashEmitter=Class'UT3Style.UT3ImpactEffectB'
     FlashEmitterAlt=Class'UT3Style.UT3ImpactEffectAltB'
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Impact_3P_Mid'
     RelativeLocation=(Y=-2.000000,Z=5.000000)
     RelativeRotation=(Yaw=49152,Roll=32768)
     DrawScale=0.800000
}

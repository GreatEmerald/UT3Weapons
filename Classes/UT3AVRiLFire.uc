//=============================================================================
// UT3AVRiLFire.uc
// Maybe for the same reason I chose the name for the sounds.
// 2008, GreatEmerald
//=============================================================================

class UT3AVRiLFire extends ONSAVRiLFire;

#EXEC OBJ LOAD FILE=UT3A_Weapon_AVRiL.uax

var(Sound) float AVRiLSoundVolume;

function Timer()
{
    if (Weapon.ClientState == WS_ReadyToFire)
    {
        Weapon.PlayAnim(ReloadAnim, ReloadAnimRate, TweenTime);
        Weapon.PlaySound(ReloadSound,SLOT_None,AVRiLSoundVolume,,512.0,,false);
        ClientPlayForceFeedback(ReloadForce);
    }
}

defaultproperties
{
    AmmoClass=class'UT3AVRiLAmmo'
    AmmoPerFire=1

    ProjectileClass=class'UT3AVRiLRocket'
    KickMomentum=(X=0,Y=0,Z=0)

    FireSound=Sound'UT3A_Weapon_AVRiL.UT3AVRiLFire.UT3AVRiLFireCue'
    ReloadSound=Sound'UT3A_Weapon_AVRiL.UT3AVRiLReload.UT3AVRiLReloadCue'
    TransientSoundVolume=0.65
    AVRiLSoundVolume=0.7
    
    FireAnim="WeaponFire"
    ReloadAnim="weaponreload"
    ReloadAnimRate=0.85
}

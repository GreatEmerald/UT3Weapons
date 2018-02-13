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

    FireSound=Sound'UT3A_Weapon_AVRiL.Fire.FireCue
    TransientSoundVolume=0.8
    ReloadSound=Sound'UT3A_Weapon_AVRiL.Singles.Reload01'
    AVRiLSoundVolume=0.7 //HDm: Does this actually do anything GE, it doesn't seem to?
    
      FireAnim="WeaponFire"
      ReloadAnim="weaponreload"
      ReloadAnimRate=0.85
}

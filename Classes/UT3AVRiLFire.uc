//=============================================================================
// UT3AVRiLFire.uc
// Maybe for the same reason I chose the name for the sounds.
// 2008, GreatEmerald
//=============================================================================

class UT3AVRiLFire extends ONSAVRiLFire;

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
     AVRiLSoundVolume=0.700000
     KickMomentum=(X=0.000000,Z=0.000000)
     FireAnim="WeaponFire"
     ReloadAnim="weaponreload"
     ReloadAnimRate=0.850000
     FireSound=Sound'UT3Weapons2.AVRiL.AVRILFire'
     ReloadSound=Sound'UT3Weapons2.AVRiL.AVRILReload'
     AmmoClass=Class'UT3Style.UT3AVRiLAmmo'
     ProjectileClass=Class'UT3Style.UT3AVRiLRocket'
}

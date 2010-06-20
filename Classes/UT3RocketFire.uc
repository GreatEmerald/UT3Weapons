//=============================================================================
// UT3RocketFire.uc
// No no, not the flames, the action!
// 2008, GreatEmerald
//=============================================================================

class UT3RocketFire extends RocketFire;

function StartFiring()
{
    Instigator.ClientMessage("UT3RocketFire: StartFiring() reached");
    if (UT3RocketLauncher(Weapon) != None)
        UT3RocketLauncher(Weapon).IncrementFireMode();
    Super.StartFiring();
}

function PlayFiring()
{
    local bool bExactSync; //GE: When true, acts like a normal fire anim but syncs with shots.
                           //When false, acts like a fluid looping animation but can go out of sync with shots.
    local UT3RocketAttachment RLAttachment;
    
    bExactSync = True;
    
    if (bExactSync && Weapon.Mesh != None && Weapon.HasAnim(FireLoopAnim))
        Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
    else if (!bExactSync && Weapon.Mesh != None && Weapon.HasAnim(FireLoopAnim))
        Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, 0.0);  
    else if (Weapon.Mesh != None && Weapon.HasAnim(FireAnim))
    {
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        if (UT3RocketLauncher(Weapon) == None || UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor) == None)
            return;
        RLAttachment = UT3RocketAttachment(UT3RocketLauncher(Weapon).ThirdPersonActor);
        RLAttachment.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    }

    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);  // jdf
    FireCount++;
}

defaultproperties
{
    AmmoClass=class'UT3RocketAmmo'

    ProjectileClass=class'UT3RocketProj'
    FireSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherFire'
    TransientSoundVolume=0.4

    FireRate=1.050000
    FireAnim="WeaponFire"
    TweenTime=0.0
}

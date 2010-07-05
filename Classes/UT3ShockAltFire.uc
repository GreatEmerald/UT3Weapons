//==============================================================================
// UT3ShockAltFire.uc
// Nothing to see here.
// 2008, GreatEmerald
//==============================================================================

class UT3ShockAltFire extends ShockProjFire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = Super(ProjectileFire).SpawnProjectile(Start,Dir);
    if ( (UT3ShockRifle(Instigator.Weapon) != None) && (p != None) )
        UT3ShockRifle(Instigator.Weapon).SetComboTarget(UT3ShockBall(P));
    return p;
}

defaultproperties
{
     TransientSoundVolume=0.800000
     FireAnim="WeaponAltFire"
     FireAnimRate=1.000000
     FireSound=Sound'UT3Weapons2.ShockRifle.ShockRifleAltFireCue'
     AmmoClass=Class'UT3Style.UT3ShockAmmo'
     ProjectileClass=Class'UT3Style.UT3ShockBall'
}

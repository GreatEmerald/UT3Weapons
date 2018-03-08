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
    AmmoClass=class'UT3ShockAmmo'
    ProjectileClass=class'UT3ShockBall'

    FireSound=Sound'UT3A_Weapon_ShockRifle.UT3ShockAltFire.UT3ShockAltFireCue'
    TransientSoundVolume=0.7
    FireRate=0.60
    FireAnim="WeaponAltFire"
    FireAnimRate=1.0
}


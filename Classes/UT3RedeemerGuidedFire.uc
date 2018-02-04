//=============================================================================
// UT3RedeemerGuidedFire.uc
// Who's the Redeemer fuerer?
// 2008, GreatEmerald
//=============================================================================

class UT3RedeemerGuidedFire extends RedeemerGuidedFire;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local RedeemerWarhead Warhead;
    local PlayerController Possessor;

    Warhead = Weapon.Spawn(class'UT3RedeemerWarhead', Instigator,, Start, Dir);
    if (Warhead == None)
        Warhead = Weapon.Spawn(class'UT3RedeemerWarhead', Instigator,, Instigator.Location, Dir);
    if (Warhead != None)
    {
        Warhead.OldPawn = Instigator;
        Warhead.PlaySound(FireSound);
        Possessor = PlayerController(Instigator.Controller);
        Possessor.bAltFire = 0;
        if ( Possessor != None )
        {
            if ( Instigator.InCurrentCombo() )
                Possessor.Adrenaline = 0;
            Possessor.UnPossess();
            Instigator.SetOwner(Possessor);
            Instigator.PlayerReplicationInfo = Possessor.PlayerReplicationInfo;
            Possessor.Possess(Warhead);
        }
        Warhead.Velocity = Warhead.AirSpeed * Vector(Warhead.Rotation);
        Warhead.Acceleration = Warhead.Velocity;
        WarHead.MyTeam = Possessor.PlayerReplicationInfo.Team;
    }
    else
    {
        Weapon.Spawn(class'SmallRedeemerExplosion');
        Weapon.HurtRadius(500, 400, class'DamTypeUT3Redeemer', 100000, Instigator.Location);
    }

    bIsFiring = false;
    StopFiring();
    return None;
}

defaultproperties
{
    ProjectileClass=class'UT3RedeemerProjectile'
    FireSound=Sound'UT3A_Weapon_Redeemer.Fire.FireCue'
    FireAnim="WeaponFire"
}

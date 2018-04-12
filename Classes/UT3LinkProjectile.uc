//==============================================================================
// UT3LinkProjectile.uc
// Just for the nice sound.
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3LinkProjectile extends LinkProjectile;

#exec obj load file=UT3A_Weapon_LinkGun.uax

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( EffectIsRelevant(Location,false) )
    {
        if (Links == 0)
            Spawn(class'LinkProjSparks',,, HitLocation, rotator(HitNormal));
        else
            Spawn(class'LinkProjSparksYellow',,, HitLocation, rotator(HitNormal));
    }
    PlaySound(Sound'UT3A_Weapon_LinkGun.UT3LinkImpact.UT3LinkImpactCue');
    Destroy();
}

defaultproperties
{
   Damage=26
   Speed=1400.000000
   MaxSpeed=5000.000000
   TransientSoundVolume=0.5
   MyDamageType=class'DamTypeUT3LinkProj'
     DrawScale=0.400000
}

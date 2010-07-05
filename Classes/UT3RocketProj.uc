//=============================================================================
// UT3RocketProj.uc
// No no, not the projector, the projectile!
// 2008, GreatEmerald
//=============================================================================

class UT3RocketProj extends RocketProj;

var() Sound ExplosionSound;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local PlayerController PC;

    PlaySound(ExplosionSound,,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'NewExplosionA',,,HitLocation + HitNormal*20,rotator(HitNormal));
        PC = Level.GetLocalPlayerController();
        if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
            Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
    }

    BlowUp(HitLocation);
    Destroy();
}

defaultproperties
{
     ExplosionSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherExplosion'
     Damage=100.000000
     MomentumTransfer=85000.000000
     MyDamageType=Class'UT3Style.DamTypeUT3Rocket'
     AmbientSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherAmb'
}

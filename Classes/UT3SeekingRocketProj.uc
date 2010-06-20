//=============================================================================
// UT3SeekingRocketProj.uc
// "It's seeking someone." "Tell him that he's away."
// 2008, GreatEmerald
//=============================================================================

class UT3SeekingRocketProj extends SeekingRocketProj;

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
    Damage=100.0
    MomentumTransfer=85000.000000
    MyDamageType=class'DamTypeUT3Rocket'
    LifeSpan=8.0
    AmbientSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherAmb'
    ExplosionSound=Sound'UT3Weapons2.RocketLauncher.RocketLauncherExplosion'
}

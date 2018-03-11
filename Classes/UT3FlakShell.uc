//==============================================================================
// UT3FlakShell.uc
// user.root$: #
// 2008, GreatEmerald
//==============================================================================

class UT3FlakShell extends flakshell;

#exec obj load file=UT3A_Weapon_FlakCannon.uax

var sound ExplosionSound;

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
    local PlayerController PC;

    PlaySound (ExplosionSound,,3*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
        PC = Level.GetLocalPlayerController();
        if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
            spawn(class'FlakExplosion',,,HitLocation + HitNormal*16 );
        spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
        spawn(class'RocketSmokeRing',,,HitLocation + HitNormal*16, rotator(HitNormal) );
        if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
            Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local vector start;
    local rotator rot;
    local int i;
    local FlakChunk NewChunk;

    start = Location + 10 * HitNormal;
    if ( Role == ROLE_Authority )
    {
        HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);
        for (i=0; i<6; i++)
        {
            rot = Rotation;
            rot.yaw += FRand()*32000-16000;
            rot.pitch += FRand()*32000-16000;
            rot.roll += FRand()*32000-16000;
            NewChunk = Spawn( class 'UT3FlakChunk',, '', Start, rot);
        }
    }
    Destroy();
}

defaultproperties
{
    Damage=100.000000
    MyDamageType=class'DamTypeUT3FlakShell'
    AmbientSound=Sound'UT3A_Weapon_FlakCannon.UT3FlakSingles.UT3FlakFireAltInAirCueAll'
    ExplosionSound=SoundGroup'UT3A_Weapon_FlakCannon.UT3FlakFireAltImpactExplode.UT3FlakFireAltImpactExplodeCue'
}


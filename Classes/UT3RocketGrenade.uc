//=============================================================================
// Grenade.
//=============================================================================
class UT3RocketGrenade extends Grenade;

#EXEC OBJ LOAD FILE=UT3A_Weapon_RocketLauncher.uax

var() Sound ExplosionSound;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);
	PlaySound(ExplosionSound, SLOT_Misc, 1.0);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'NewExplosionB',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }
    Destroy();
}

defaultproperties
{
     TossZ=+245.0
     DrawScale=1.0
     MyDamageType=class'DamTypeUT3RocketGrenade'
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
     Speed=700
     MaxSpeed=1000.0
     Damage=100.0
     DamageRadius=200
     MomentumTransfer=50000
     ImpactSound=Sound'UT3A_Weapon_RocketLauncher.UT3RocketGrenadeFloor.UT3RocketGrenadeFloorCue'
     ExplosionSound=Sound'UT3A_Weapon_RocketLauncher.UT3RocketImpact.UT3RocketImpactCue'
     
}

//-----------------------------------------------------------
// UT3GoliathCannon.uc
// Go over to the Projectile.
// GreatEmerald, 2008
//-----------------------------------------------------------
class UT3GoliathCannon extends ONSHoverTankCannon;

var()   sound           ReloadSoundClass;

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local ONSWeaponPawn WeaponPawn;
    local vector StartLocation, HitLocation, HitNormal, Extent;

    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1,1,0);
        Extent.Z = ProjClass.default.CollisionHeight;
        WeaponPawn = ONSWeaponPawn(Owner);
        if (WeaponPawn != None && WeaponPawn.VehicleBase != None)
        {
            if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
            StartLocation = HitLocation;
        else
            StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
    }
    else
    {
        if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            StartLocation = HitLocation;
        else
            StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
    }
    }
    else
        StartLocation = WeaponFireLocation;

    P = spawn(ProjClass, self, , StartLocation, WeaponFireRotation);

    if (P != None)
    {
        if (bInheritVelocity)
            P.Velocity = Instigator.Velocity;

        FlashMuzzleFlash();

        // Play firing noise
        if (bAltFire)
        {
            if (bAmbientAltFireSound)
                AmbientSound = AltFireSoundClass;
            else
                PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume/255.0,, AltFireSoundRadius,, false);
        }
        else
        {
            if (bAmbientFireSound)
                AmbientSound = FireSoundClass;
            else {
                PlayOwnedSound(FireSoundClass, SLOT_None, FireSoundVolume/255.0,, FireSoundRadius,, false);
                SetTimer(1.2, false);
            }
        }
    }

    return P;
}

Simulated Function Timer()
{
  PlaySound(ReloadSoundClass, SLOT_None, FireSoundVolume/255.0,, FireSoundRadius,, false);
}

DefaultProperties
{
  ProjectileClass=class'UT3GoliathProjectile'
  FireSoundClass=sound'UT3Vehicles.Goliath.GoliathFire'
  ReloadSoundClass=sound'UT3Vehicles.Goliath.GoliathReload'
}

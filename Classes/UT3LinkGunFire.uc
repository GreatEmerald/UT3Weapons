//==============================================================================
// UT3LinkGunFire.uc
// This + Berserk = Pwnage
// 2008, GreatEmerald
//==============================================================================

class UT3LinkGunFire extends LinkAltFire;

var class<LinkProjectile> LinkProj;

function Projectile SpawnProjectile(Vector Start, Rotator Dir) //Custom projectile
{
    local LinkProjectile Proj;

    Start += Vector(Dir) * 10.0 * LinkGun(Weapon).Links;
    Proj = Weapon.Spawn(LinkProj,,, Start, Dir);
    if ( Proj != None )
    {
        Proj.Links = LinkGun(Weapon).Links;
        Proj.LinkAdjust();
    }
    return Proj;
}


//GE: Start muzzleflash support.
simulated function Vector GetTipLocation()
{
    local Coords C;
    C = Weapon.GetBoneCoords('tip');
    return C.Origin;
}

simulated function Rotator GetTipRotation()
{
    local Rotator R;
    R = Weapon.GetBoneRotation('tip');
    return R;
}

function DrawMuzzleFlash(Canvas Canvas)
{
    if (SmokeEmitter != None)
    {
        SmokeEmitter.SetRotation( GetTipRotation() );
        SmokeEmitter.SetLocation( GetTipLocation() );
        Canvas.DrawActor( SmokeEmitter, false, false, Weapon.DisplayFOV );
    }
    
    if (FlashEmitter != None)
    {
        FlashEmitter.SetRotation( GetTipRotation() );
        FlashEmitter.SetLocation( GetTipLocation() );
        Canvas.DrawActor( FlashEmitter, false, false, Weapon.DisplayFOV );
    }

}
//GE: End MuzzleFlash support.

defaultproperties
{
     LinkProj=Class'UT3Style.UT3LinkProjectile'
     LinkedFireSound=Sound'UT3Style.LinkGun.LinkGunFire'
     FireAnim="WeaponFire"
     FireSound=Sound'UT3Style.LinkGun.LinkGunFire'
     FireRate=0.160000
     AmmoClass=Class'UT3Style.UT3LinkAmmo'
     AmmoPerFire=1
}

//==============================================================================
// UT3LinkGunFire.uc
// This + Berserk = Pwnage
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3LinkGunFire extends LinkAltFire;

#exec obj load file=UT3A_Weapon_LinkGun.uax

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
  LinkProj=class'UT3LinkProjectile'
  AmmoClass=class'UT3LinkAmmo'
  FireSound=Sound'UT3A_Weapon_LinkGun.UT3LinkFire.UT3LinkFireCue'
  LinkedFireSound=Sound'UT3A_Weapon_LinkGun.UT3LinkFire.UT3LinkFireCue'
  TransientSoundVolume=0.7
  FireRate=0.16
  AmmoPerFire=1
  FireAnim="WeaponFire"
}

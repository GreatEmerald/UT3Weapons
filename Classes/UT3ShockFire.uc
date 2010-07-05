//==============================================================================
// UT3ShockFire.uc
// Laser Rifle...
// 2008, GreatEmerald
//==============================================================================

class UT3ShockFire extends ShockBeamFire;

function DoFireEffect()
{
    local Vector StartTrace,X,Y,Z;
    local Rotator R, Aim;

    Instigator.MakeNoise(1.0);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    if ( PlayerController(Instigator.Controller) != None )
    {
        // for combos
       Weapon.GetViewAxes(X,Y,Z);
        StartTrace = StartTrace + X*class'UT3ShockAltFire'.Default.ProjSpawnOffset.X;
        if ( !Weapon.WeaponCentered() )
            StartTrace = StartTrace + Weapon.Hand * Y*class'UT3ShockAltFire'.Default.ProjSpawnOffset.Y + Z*class'UT3ShockAltFire'.Default.ProjSpawnOffset.Z;
    }

    Aim = AdjustAim(StartTrace, AimError);
    R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
}

function Rotator AdjustAim(Vector Start, float InAimError)
{
    if ( (UT3ShockRifle(Weapon) != None) && (UT3ShockRifle(Weapon).ComboTarget != None) )
        return Rotator(UT3ShockRifle(Weapon).ComboTarget.Location - Start);

    return Super.AdjustAim(Start, InAimError);
}

defaultproperties
{
     DamageType=Class'UT3Style.DamTypeUT3ShockBeam'
     TransientSoundVolume=0.470000
     FireAnim="WeaponFire"
     FireAnimRate=0.733300
     FireSound=SoundGroup'UT3Weapons2.ShockRifle.ShockRifleFireCue'
     FireRate=0.770000
     AmmoClass=Class'UT3Style.UT3ShockAmmo'
}

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
    AmmoClass=class'UT3ShockAmmo'
    FireSound=SoundGroup'UT3A_Weapon_ShockRifle.UT3ShockFire.UT3ShockFireCue'
    TransientSoundVolume=0.75
    FireRate=0.77
    Momentum=60000.000000
    DamageType=class'DamTypeUT3ShockBeam'
    FireAnim="WeaponFire"
    FireAnimRate=0.7333
}

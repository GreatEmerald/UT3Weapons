//==============================================================================
// UT3LinkGunAltFire.uc
// Hmm, how does this work?
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3LinkGunAltFire extends LinkFire;

#exec obj load file=UT3A_Weapon_LinkGun.uax

var Sound PreFireSound, PostFireSound;

function PlayFiring()
{
	  bStartFire = true;
    if (LinkGun(Weapon).Links <= 0 && Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire)
		    ClientPlayForceFeedback("BLinkGunBeam1");

    if ( Weapon.Mesh != None && FireCount > 0 && Weapon.HasAnim(FireLoopAnim) )
    {
        Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, 0.0);//GE: Cound someone explain why in the world doesn't fireLOOPANIM call LOOPANIM by default?!
    }
    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;

}

function PlayPreFire()
{
    if ( Weapon.Mesh != None && Weapon.HasAnim(PreFireAnim) )
    {
        Weapon.PlayAnim(PreFireAnim, PreFireAnimRate, TweenTime);
        //Instigator.ClientMessage("UT3LinkGunAltFire: Playing"@PreFireAnim);
    }
    Weapon.PlayOwnedSound(PreFireSound, SLOT_Interact, TransientSoundVolume*1.1);
    //bStartFire = False;
}

function PlayFireEnd()
{
    Super.PlayFireEnd();
    Weapon.PlayOwnedSound(PostFireSound, SLOT_Interact, TransientSoundVolume*1.1);
}

function StopFiring()
{
	Instigator.AmbientSound = None;
	Instigator.SoundVolume = Instigator.Default.SoundVolume;
    if (Beam != None)
    {
        Beam.Destroy();
        Beam = None;
    }
    SetLinkTo(None);
    bStartFire = true;
    bFeedbackDeath = false;
    if (LinkGun(Weapon).Links <= 0)
		StopForceFeedback("BLinkGunBeam1");
}


//GE: Start muzzleflash support.
simulated function Vector GetTipLocation()
{
    local Coords C;
    C = Weapon.GetBoneCoords('beamtip');
    return C.Origin;
}

simulated function Rotator GetTipRotation()
{
    local Rotator R;
    R = Weapon.GetBoneRotation('beamtip');
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
    AmmoClass=class'UT3LinkAmmo'
    Damage=11
    FireRate=0.1
    
    PreFireSound=SoundGroup'UT3A_Weapon_LinkGun.AltFireStart.AltFireStartCue'
    PostFireSound=SoundGroup'UT3A_Weapon_LinkGun.AltFireStop.AltFireStopCue'
    MakeLinkSound=SoundGroup'UT3A_Weapon_LinkGun.AltFireStart.AltFireStartCue'
    BeamSounds(0)=Sound'UT3A_Weapon_LinkGun.Singles.AltFire01'
    BeamSounds(1)=Sound'UT3A_Weapon_LinkGun.Singles.AltFireImpact'
    BeamSounds(2)=Sound'UT3A_Weapon_LinkGun.Singles.AltFireImpactFlesh'
    BeamSounds(3)=Sound'UT3A_Weapon_LinkGun.Singles.AltFireImpactFlesh'

    BeamEffectClass=Class'UT3LinkBeamEffect'

    bInitAimError=false
    MomentumTransfer=10000.000000 //GE: Originally 50000
    DamageType=class'DamTypeUT3LinkBeam'


    // TODO: Make it really sound when it hits different materials

     PreFireAnim="WeaponAltFireStart"
     FireAnim=
     FireLoopAnim="WeaponAltFire"
     FireEndAnim="WeaponAltFireEnd"
     PreFireTime=0.3
     FireEndAnimRate=0.500000
}

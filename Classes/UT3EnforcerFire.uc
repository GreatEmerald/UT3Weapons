//==============================================================================
// UT3EnforcerFire.uc
// Bam.
// 2008, GreatEmerald
//==============================================================================

class UT3EnforcerFire extends AssaultFire;

var() class<ShockBeamEffect> BeamEffectClass; //GE: Hax! Only ShockBeamEffect supports AimAt()! Though is it necessary?

function InitEffects()
{
    Super(InstantFire).InitEffects();
    if ( FlashEmitter != None )
    
        Weapon.AttachToBone(FlashEmitter, 'tip');
        //Instigator.ClientMessage("UT3Style: UT3EnforcerFire: FlashEmitter is"@FlashEmitter);
    
}

function DrawMuzzleFlash(Canvas Canvas)
{
    local rotator R;
    
    // Draw smoke first
    if (SmokeEmitter != None && SmokeEmitter.Base != Weapon)
    {
        SmokeEmitter.SetLocation( Weapon.GetEffectStart() );
        Canvas.DrawActor( SmokeEmitter, false, false, Weapon.DisplayFOV );
    }

    //Instigator.ClientMessage("UT3Style.UT3EnforcerFire: Attempting to draw the MuzzleFlash...");
    //Instigator.ClientMessage("UT3Style.UT3EnforcerFire: FlashEmitter's base is:"@FlashEmitter.Base);
    if (FlashEmitter != None)// && FlashEmitter.Base != Weapon)
    {
        FlashEmitter.SetLocation( Weapon.GetEffectStart() );
        R = Instigator.GetViewRotation();//Weapon.GetBoneRotation('tip');
        //R.Yaw+=16384;
        FlashEmitter.SetRotation(R);
        //Instigator.Weapon.AttachToBone(FlashEmitter, 'tip');
        Canvas.DrawActor( FlashEmitter, false, false, Weapon.DisplayFOV );
        //Instigator.ClientMessage("UT3Style.UT3EnforcerFire: FlashEmitter is drawn at"@Weapon.GetEffectStart());
    }
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
    local ShockBeamEffect Beam;

    if (Weapon != None)
    {
        Beam = Weapon.Spawn(BeamEffectClass,,, Start, Dir);
        if (ReflectNum != 0) Beam.Instigator = None; // prevents client side repositioning of beam start
            Beam.AimAt(HitLocation, HitNormal);
    }
}

function PlayFiring()
{
    local bool bExactSync; //GE: When true, acts like a normal fire anim but syncs with shots.
                           //When false, acts like a fluid looping animation but can go out of sync with shots.
    
    bExactSync = True;
    
    if (bExactSync && Weapon.Mesh != None && Weapon.HasAnim(FireLoopAnim))
        Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
    else if (!bExactSync && Weapon.Mesh != None && Weapon.HasAnim(FireLoopAnim))
        Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, 0.0);  
    else if (Weapon.Mesh != None && Weapon.HasAnim(FireAnim))
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);

    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);  // jdf
    FireCount++;
}

defaultproperties
{
     BeamEffectClass=Class'UT3Style.UT3EnforcerEffect'
     DamageType=Class'UT3Style.DamTypeUT3Enforcer'
     DamageMin=20
     DamageMax=20
     Momentum=1000.000000
     FireAnim="WeaponFire"
     FireSound=Sound'UT3Weapons.Enforcer.EnforcerPrimary2'
     FireRate=0.360000
     AmmoClass=Class'UT3Style.UT3EnforcerAmmo'
     BotRefireRate=0.360000
     aimerror=600.000000
     Spread=0.030000
}

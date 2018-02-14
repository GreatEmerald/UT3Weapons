//=============================================================================
// UT3SniperFire.uc
// Head Shot.
// 2008, 2014 GreatEmerald
//=============================================================================

class UT3SniperFire extends SniperFire;

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, RefNormal;
    local Actor Other, mainArcHitTarget;
    local int Damage, ReflectNum, arcsRemaining;
    local bool bDoReflect;
    local xEmitter hitEmitter;
    local class<Actor> tmpHitEmitClass;
    local float tmpTraceRange;
    local vector arcEnd, mainArcHit;
    local Pawn HeadShotPawn;
    local vector EffectOffset;

    if ( UT3SniperRifle(Weapon) == None ) //GE: OK, who's the wise guy that put this at the END of the function in the original class?!
        return;

    if ( class'PlayerController'.Default.bSmallWeapons ) //GE: Interesting, since bSmallWeapons is globalconfig, it gets read from the INI.
        EffectOffset = Weapon.SmallEffectOffset;
    else
        EffectOffset = Weapon.EffectOffset;

    Weapon.GetViewAxes(X, Y, Z);
    /*log(self@"DoTrace: Zoomed"@UT3SniperRifle(Weapon).zoomed@"Instigator"@Instigator.Location@"EffectOffset"@EffectOffset.Z@"Z"@Z);
    if (UT3SniperRifle(Weapon).zoomed )
        arcEnd = (Instigator.Location +
            EffectOffset.Z * Z);
    else*/
        arcEnd = Weapon.GetEffectStart(); //GE: Making it use bone coords instead of fooling around trying to calc it itself.

    arcsRemaining = NumArcs;

    tmpHitEmitClass = HitEmitterClass;
    tmpTraceRange = TraceRange;

    /*ReflectNum = 0;
    while (true)
    {*/
        bDoReflect = false;
        X = Vector(Dir);
        End = Start + tmpTraceRange * X;
        Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
            {
                bDoReflect = true;
            }
            else if ( Other != mainArcHitTarget )
            {
                if ( !Other.bWorldGeometry )
                {
                    Damage = (DamageMin + Rand(DamageMax - DamageMin)) * DamageAtten;

                    if (Vehicle(Other) != None)
                        HeadShotPawn = Vehicle(Other).CheckForHeadShot(HitLocation, X, 1.0);

                    if (HeadShotPawn != None)
                        HeadShotPawn.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
                    else if ( (Pawn(Other) != None) && (arcsRemaining == NumArcs)
                        && Pawn(Other).IsHeadShot(HitLocation, X, 1.0) )
                        Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
                    else
                    {
                        if ( arcsRemaining < NumArcs )
                            Damage *= SecDamageMult;
                        Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
                    }
                }
                else
                    HitLocation = HitLocation + 2.0 * HitNormal;
            }
        }
        else
        {
            HitLocation = End;
            HitNormal = Normal(Start - End);
        }

        hitEmitter = xEmitter(Weapon.Spawn(tmpHitEmitClass,,, arcEnd, Rotator(HitNormal)));
        if ( hitEmitter != None )
            hitEmitter.mSpawnVecA = HitLocation;
        if ( HitScanBlockingVolume(Other) != None )
            return;

        if( arcsRemaining == NumArcs )
        {
            mainArcHit = HitLocation + (HitNormal * 2.0);
            if ( Other != None && !Other.bWorldGeometry )
                mainArcHitTarget = Other;
        }

        /*if (bDoReflect && ++ReflectNum < 4)
        {
            //Log("reflecting off"@Other@Start@HitLocation);
            Start = HitLocation;
            Dir = Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else if ( arcsRemaining > 0 )
        {
            arcsRemaining--;

            // done parent arc, now move trace point to arc trace hit location and try child arcs from there
            Start = mainArcHit;
            Dir = Rotator(VRand());
            tmpHitEmitClass = SecHitEmitterClass;
            tmpTraceRange = SecTraceDist;
            arcEnd = mainArcHit;
        }
        else
        {
            break;
        }
    }*/
}

function DrawMuzzleFlash(Canvas Canvas)
{
    if (UT3SniperRifle(Weapon) == None)
        return;

    // Draw smoke first
    if (SmokeEmitter != None)
    {
        SmokeEmitter.SetLocation( Weapon.GetEffectStart() );
        FlashEmitter.SetRotation(Weapon.GetBoneRotation('tip'));
        Canvas.DrawActor( SmokeEmitter, false, false, Weapon.DisplayFOV );
    }

    if (FlashEmitter != None)
    {
        FlashEmitter.SetLocation( Weapon.GetEffectStart() );
        FlashEmitter.SetRotation(Weapon.GetBoneRotation('tip'));
        Canvas.DrawActor( FlashEmitter, false, false, Weapon.DisplayFOV );
    }
}

function FlashMuzzleFlash()
{
    if (UT3SniperRifle(Weapon) == None || UT3SniperRifle(Weapon).zoomed)
        return;
    Super.FlashMuzzleFlash();
}

function PlayFiring()
{
    Super(InstantFire).PlayFiring();
}

defaultproperties
{
    AmmoClass=class'UT3SniperAmmo'
    DamageType=class'DamTypeUT3Sniper'
    DamageTypeHeadShot=class'DamTypeUT3HeadShot'
    DamageMin=70
    DamageMax=70
    FireSound=SoundGroup'UT3A_Weapon_Sniper.Fire.FireCue'
    TransientSoundVolume=1.4000
    aimerror=600.000000
    FireAnim="WeaponFire"
    FireAnimRate=1.1
    FireRate=1.33
    NumArcs=0
    HitEmitterClass=class'UT3SniperEffect'
    FlashEmitterClass=class'XEffects.AssaultMuzFlash1st'
}

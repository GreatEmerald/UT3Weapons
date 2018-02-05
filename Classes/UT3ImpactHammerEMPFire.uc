//==============================================================================
// UT3ImpactHammerEMPFire.uc
// Mantas are dead.
// 2008, GreatEmerald
//==============================================================================
class UT3ImpactHammerEMPFire extends ShieldFire;

var name TipBone;
var Sound WindingSound;
var bool bWinding;

function PlayPreFire()
{
    Super(WeaponFire).PlayPreFire();
}

simulated function InitEffects()
{
    bStartedChargingForce = false;  // jdf
    Super(WeaponFire).InitEffects();
}

function DoFireEffect()
{
    local Vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
    local Rotator Aim;
    local Actor Other;
    local float Scale, Damage, Force;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);
    bAutoRelease = false;

    if ( (AutoHitPawn != None) && (Level.TimeSeconds - AutoHitTime < 0.15) )
    {
        Other = AutoHitPawn;
        HitLocation = Other.Location;
        AutoHitPawn = None;
    }
    else
    {
        StartTrace = Instigator.Location;
        Aim = AdjustAim(StartTrace, AimError);
        EndTrace = StartTrace + ShieldRange * Vector(Aim);
        Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
    }

    Scale = (FClamp(HoldTime, MinHoldTime, FullyChargedTime) - MinHoldTime) / (FullyChargedTime - MinHoldTime); // result 0 to 1
    Damage = MinDamage + Scale * (MaxDamage - MinDamage);
    Force = MinForce + Scale * (MaxForce - MinForce);

    Instigator.AmbientSound = None;
    //Instigator.SoundVolume = Instigator.Default.SoundVolume;

    if (ChargingEmitter != None)
        ChargingEmitter.mRegenPause = true;

    if ( Other != None && Other != Instigator )
    {
        if (Vehicle(Other) != None || (Decoration(Other) != None && Decoration(Other).bDamageable) )
            Other.TakeDamage(Damage, Instigator, HitLocation, Force*(X+vect(0,0,0.5)), DamageType);
        else
        {
            if ( xPawn(Instigator).bBerserk )
                Force *= 2.0;
            Instigator.TakeDamage(MinSelfDamage+SelfDamageScale*Damage, Instigator, HitLocation, -SelfForceScale*Force*X, DamageType);
            if ( DestroyableObjective(Other) != None )
                Other.TakeDamage(Damage, Instigator, HitLocation, Force*(X+vect(0,0,0.5)), DamageType);
        }
    }

    SetTimer(0, false);
    bWinding = False;
}

function Timer() //GE: Adding WindingSound support.
{
    local Actor Other;
    local Vector HitLocation, HitNormal, StartTrace, EndTrace;
    local Rotator Aim;
    local float ChargeScale;
    local float WindingDuration;

    if (HoldTime > 0.0 && !bNowWaiting)
    {
        StartTrace = Instigator.Location;
        Aim = AdjustAim(StartTrace, AimError);
        EndTrace = StartTrace + ShieldRange * Vector(Aim);

        Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
        if (WindingSound != None)
            WindingDuration = Weapon.GetSoundDuration(WindingSound);
        
        if ( (Pawn(Other) != None) && (Other != Instigator) )
        {
            bAutoRelease = true;
            bIsFiring = false;
            Instigator.AmbientSound = None;
            //Instigator.SoundVolume = Instigator.Default.SoundVolume;
            AutoHitPawn = Pawn(Other);
            AutoHitTime = Level.TimeSeconds;
            if (ChargingEmitter != None)
                ChargingEmitter.mRegenPause = true;
        }
        else if (HoldTime < WindingDuration*Level.TimeDilation)
        {
            if (!bWinding)
                Weapon.PlayOwnedSound(WindingSound, SLOT_Interact);
            bWinding = True;
            ChargeScale = FMin(HoldTime, FullyChargedTime);
            if (!bStartedChargingForce)
            {
                bStartedChargingForce = true;
                ClientPlayForceFeedback( ChargingForce );
            }
        }
        else
        {
            Instigator.AmbientSound = ChargingSound;
            //Instigator.SoundVolume = ChargingSoundVolume;
            ChargeScale = FMin(HoldTime, FullyChargedTime);
            bWinding = False;
        }
    }
    else
    {
        if ( Instigator.AmbientSound == ChargingSound )
        {
            Instigator.AmbientSound = None;
            //Instigator.SoundVolume = Instigator.Default.SoundVolume;
        }

        SetTimer(0, false);
    }
}


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
    if (FlashEmitter != None)
    {
        FlashEmitter.SetRotation( GetTipRotation() );
        FlashEmitter.SetLocation( GetTipLocation() );
        Canvas.DrawActor( FlashEmitter, false, false, Weapon.DisplayFOV );
    }

    if ( (Instigator.AmbientSound == ChargingSound) && ((HoldTime <= 0.0) || bNowWaiting) )
    {
        Instigator.AmbientSound = None;
        //Instigator.SoundVolume = Instigator.Default.SoundVolume;
    }

}

defaultproperties
{
    WindingSound=Sound'UT3A_Weapon_ImpactHammer.Singles.AltFireLoopCueStart'
    ChargingSound=Sound'UT3A_Weapon_ImpactHammer.Singles.AltFireLoopCue'
    FireSound=SoundGroup'UT3A_Weapon_ImpactHammer.AltImpact.AltImpactCue'
    TransientSoundVolume=1.5
    MinDamage=0.0
    MaxDamage=150.0
    ShieldRange=220.0
    FullyChargedTime=2.5
    DamageType=class'DamTypeImpactEMP'
    MinSelfDamage=0
    SelfDamageScale=0
    SelfForceScale=0.0
    MinForce=130000.0
    MaxForce=200000.0
    //ChargingSoundVolume=500
    FireRate=1.1
    FlashEmitterClass=class'UT3ImpactEffectAlt'
    
     PreFireAnim="WeaponCharge"
     PreFireAnimRate=0.7333
     FireAnim="WeaponFire"
     FireAnimRate=0.7333
     TipBone="tip"
}

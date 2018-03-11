//==============================================================================
// UT3MinigunFire.uc
// Those tarydium crystals still look cool.
// 2008, GreatEmerald
//==============================================================================

class UT3MinigunFire extends InstantFire;

#exec OBJ LOAD FILE=UT3Weapons2.uax

// For controlling the roll of the barrel
var() float MaxRollSpeed;
var() float RollSpeed;
var() float BarrelRotationsPerSec;
var() int   RoundsPerRotation;
var() float FireTime;
var() Sound WindingSound;
var() Sound PostFireSound, FireOnceSound;
var() byte  MinigunSoundVolume;
var UT3Minigun2v Gun;
var() float WindUpTime;
var bool bActivateFullSpeed, bFireEnd;

var() String FiringForce;
var() String WindingForce;

var() class<ShockBeamEffect> BeamEffectClass; //GE: Hax! Only ShockBeamEffect supports AimAt()! Though is it necessary?

function StartBerserk()
{
    if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
        return;
    DamageMin = default.DamageMin * 1.33;
    DamageMax = default.DamageMax * 1.33;
}

function StopBerserk()
{
    if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
        return;
    DamageMin = default.DamageMin;
    DamageMax = default.DamageMax;
}

function StartSuperBerserk()
{
    DamageMin = default.DamageMin * 1.5;
    DamageMax = default.DamageMax * 1.5;
    BarrelRotationsPerSec = Default.BarrelRotationsPerSec * 0.667 * Level.GRI.WeaponBerserk;
    FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
    MaxRollSpeed = 65536.f*BarrelRotationsPerSec;
}

function PostBeginPlay()
{
    Super.PostBeginPlay();
    FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
    MaxRollSpeed = 65536.f*BarrelRotationsPerSec;
    Gun = UT3Minigun2v(Weapon);
}

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
        Weapon.AttachToBone(FlashEmitter, 'flash');
}

function PlayAmbientSound(Sound aSound)
{
    if ( (UT3Minigun2v(Weapon) == None) || (Instigator == None) || (aSound == None && ThisModeNum != Gun.CurrentMode) )
        return;

    if(aSound == None)
        Instigator.SoundVolume = Instigator.default.SoundVolume;
    else
        Instigator.SoundVolume = MinigunSoundVolume;

    Instigator.AmbientSound = aSound;
    Gun.CurrentMode = ThisModeNum;
}

function PlayFiring()
{
    if (FireCount == 0)
        PlayWinding();
    ClientPlayForceFeedback(FireForce);  // jdf
    Weapon.PlayOwnedSound(FireOnceSound, SLOT_Interact, TransientSoundVolume*1.1);

    FireCount++;
}

function PlayWinding()
{
    if (!bIsFiring)
    {
        StopForceFeedback(FireForce);
        bFireEnd = True;
        return;
    }
    
    if ( Weapon.Mesh != None && Weapon.HasAnim(PreFireAnim) )
    {
        Weapon.PlayAnim(PreFireAnim, PreFireAnimRate, TweenTime);
    }
    BarrelRotationsPerSec = 1/WindUpTime; //GE: Needs replication!
    FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
    bActivateFullSpeed = true;
    bFireEnd = False;
    SetTimer(WindUpTime, false);
    
}

function PlayFullSpeed()
{
    if (!bIsFiring && !bFireEnd)
    {
        StopForceFeedback(FireForce);
        return;
    }
    
    BarrelRotationsPerSec = default.BarrelRotationsPerSec; //GE: Needs replication!
    FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
    if ( Weapon.Mesh != None )
    {
        if ( FireCount > 0 || !Weapon.HasAnim(FireAnim) )
        {
            if ( Weapon.HasAnim(FireLoopAnim) )
            {
                Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
            }
            else
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
            }
        }
        else
        {
            Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        }
    }
    PlayAmbientSound(WindingSound);
}

event Timer()
{
    if (bActivateFullSpeed)
    {
        PlayFullSpeed();
        bActivateFullSpeed = False;
    }
    
    Super.Timer();
}

function PlayPreFire()
{
    Super.PlayPreFire();
    //Weapon.PlayOwnedSound(WindingSound, SLOT_None, TransientSoundVolume*1.1);
}

function PlayFireEnd()
{
    Super.PlayFireEnd();
    if (Instigator.AmbientSound != None)
    {
        PlayAmbientSound(None);
        Weapon.PlayOwnedSound(PostFireSound, SLOT_Interact, TransientSoundVolume*1.1);
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

/*function StopRolling()
{
    if (Gun == None || ThisModeNum != Gun.CurrentMode)
        return;

    RollSpeed = 0.f;
    Gun.RollSpeed = 0.f;
}


function bool IsIdle()
{
    return false;
}

auto state Idle //GE: No longer code controlled.
{
    function bool IsIdle()
    {
        return true;
    }

    function BeginState()
    {
        PlayAmbientSound(None);
        StopRolling();
    }

    function EndState()
    {
        PlayAmbientSound(WindingSound);
    }

    function StartFiring()
    {
        RollSpeed = 0;
        FireTime = (RollSpeed/MaxRollSpeed) * WindUpTime;
        GotoState('WindUp');
    }
}

state WindUp
{
    function BeginState()
    {
        ClientPlayForceFeedback(WindingForce);  // jdf
    }

    function EndState()
    {
        if (ThisModeNum == 0)
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(1).bIsFiring )
                StopForceFeedback(WindingForce);
        }
        else
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(0).bIsFiring )
                StopForceFeedback(WindingForce);
        }
    }

    function ModeTick(float dt)
    {
        FireTime += dt;
        RollSpeed = (FireTime/WindUpTime) * MaxRollSpeed;

        if ( !bIsFiring )
        {
            GotoState('WindDown');
            return;
        }

        if (RollSpeed >= MaxRollSpeed)
        {
            RollSpeed = MaxRollSpeed;
            FireTime = WindUpTime;
            Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
            GotoState('FireLoop');
            return;
        }

        Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
    }

    function StopFiring()
    {
        GotoState('WindDown');
    }
}

state FireLoop
{
    function BeginState()
    {
        NextFireTime = Level.TimeSeconds - 0.1; //fire now!
        PlayAmbientSound(FiringSound);
        ClientPlayForceFeedback(FiringForce);  // jdf
        Gun.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
        Gun.SpawnShells(RoundsPerRotation*BarrelRotationsPerSec);
    }

    function StopFiring()
    {
        GotoState('WindDown');
    }

    function EndState()
    {
        PlayAmbientSound(WindingSound);
        StopForceFeedback(FiringForce);  // jdf
        Gun.LoopAnim(Gun.IdleAnim, Gun.IdleAnimRate, TweenTime);
        Gun.SpawnShells(0.f);
     }

    function ModeTick(float dt)
    {
        Super.ModeTick(dt);
        Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
        if ( !bIsFiring )
        {
            GotoState('WindDown');
            return;
        }
    }
}

state WindDown
{
    function BeginState()
    {
        ClientPlayForceFeedback(WindingForce);  // jdf
    }

    function EndState()
    {
        if (ThisModeNum == 0)
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(1).bIsFiring )
                StopForceFeedback(WindingForce);
        }
        else
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(0).bIsFiring )
                StopForceFeedback(WindingForce);
        }
    }

    function ModeTick(float dt)
    {
        FireTime -= dt;
        RollSpeed = (FireTime/WindUpTime) * MaxRollSpeed;

        if (RollSpeed <= 0.f)
        {
            RollSpeed = 0.f;
            FireTime = 0.f;
            Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
            GotoState('Idle');
            return;
        }

        Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
    }

    function StartFiring()
    {
        GotoState('WindUp');
    }
} */





defaultproperties
{
    BarrelRotationsPerSec=2.2

    AmmoClass=class'UT3MinigunAmmo'
    DamageMin=14
    DamageMax=14
    Spread=0.0675

    FiringSound=Sound'UT3A_Weapon_Stinger.UT3StingerSingles.UT3StingerFireLoop01CueAll' //don't think this works and ever replaces fire once soundgroup
    WindingSound=Sound'UT3A_Weapon_Stinger.UT3StingerSingles.UT3StingerBarrelWindLoop01'
    FireOnceSound=SoundGroup'UT3A_Weapon_Stinger.UT3StingerFire.UT3StingerFireCue'
    PostFireSound=Sound'UT3A_Weapon_Stinger.UT3StingerSingles.UT3StingerStingerRapidStop'
    MinigunSoundVolume=225

    Momentum=+0.0
    RoundsPerRotation=5
    AmmoPerFire=1
    DamageType=class'UT3DamTypeMinigun'
    bPawnRapidFireAnim=true
    SpreadStyle=SS_Random

     PreFireAnim="WeaponRampUp"
     FireAnim=
     FireLoopAnim="WeaponFire"
     FireEndAnim="WeaponRampDown"
     FireLoopAnimRate=1.200000
     FireForce="minifireb"
    WindUpTime=0.95
    //PreFireTime=1.3
    TweenTime=0.1
    
    

    FlashEmitterClass=class'XEffects.MinigunMuzFlash1st'
    //SmokeEmitterClass=class'xEffects.MinigunMuzzleSmoke'
    FiringForce="minifireb"  // jdf
    WindingForce="miniempty"  // jdf

    BotRefireRate=0.99
    AimError=900
    
    BeamEffectClass=Class'UT3EnforcerEffect'

}

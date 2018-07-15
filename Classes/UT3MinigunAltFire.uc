//==============================================================================
// UT3MinigunAltFire.uc
// This will be tough...
// 2008, GreatEmerald
//==============================================================================

class UT3MinigunAltFire extends ProjectileFire;

#exec OBJ LOAD FILE=UT3Weapons2.uax

// For controlling the roll of the barrel
var() float MaxRollSpeed;
var() float RollSpeed;
var() float BarrelRotationsPerSec;
var() int   RoundsPerRotation;
var() float FireTime;
var() Sound WindingSound;
//var() Sound FiringSound;
var() byte	MinigunSoundVolume;
var UT3Minigun2v Gun;
var() float WindUpTime;

var() String FiringForce;
var() String WindingForce;

/*function StartBerserk()
{}

function StopBerserk()
{}

function StartSuperBerserk()
{}*/

function PostBeginPlay()
{
    Super.PostBeginPlay();
    FireRate = 1.f / (RoundsPerRotation * BarrelRotationsPerSec);
    MaxRollSpeed = 65536.f*BarrelRotationsPerSec;
    Gun = UT3Minigun2v(Weapon);
}

function FlashMuzzleFlash()
{
    local rotator r;
    r.Roll = Rand(65536);
    Weapon.SetBoneRotation('Bone_Flash', r, 0, 1.f);
    Super.FlashMuzzleFlash();
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

/*function StopRolling()
{
    if (Gun == None || ThisModeNum != Gun.CurrentMode)
        return;

    RollSpeed = 0.f;
    Gun.RollSpeed = 0.f;
}

function PlayPreFire() {}
function PlayStartHold() {}
function PlayFiring() {Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);}
function PlayFireEnd() {}
function StartFiring();
function StopFiring();
function bool IsIdle()
{
	return false;
}

auto state Idle
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
        //PlayAmbientSound(FiringSound);
        ClientPlayForceFeedback(FiringForce);  // jdf
        Gun.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
//        Gun.SpawnShells(RoundsPerRotation*BarrelRotationsPerSec);
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


function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int p;
    local int SpawnCount;
    local float theta;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X*ProjSpawnOffset.X;
    if ( !Weapon.WeaponCentered() )
	    StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, ProjPerFire * int(Load));

    switch (SpreadStyle)
    {
    case SS_Random:
        X = Vector(Aim);
        for (p = 0; p < SpawnCount; p++)
        {
            R.Yaw = Spread * (FRand()-0.5);
            R.Pitch = Spread * (FRand()-0.5);
            R.Roll = Spread * (FRand()-0.5);
            SpawnProjectile(StartProj, Rotator(X >> R));
        }
        break;
    case SS_Line:
        for (p = 0; p < SpawnCount; p++)
        {
            theta = Spread*PI/32768*(p - float(SpawnCount-1)/2.0);
            X.X = Cos(theta);
            X.Y = Sin(theta);
            X.Z = 0.0;
            SpawnProjectile(StartProj, Rotator(X >> Aim));
        }
        break;
    default:
        SpawnProjectile(StartProj, Aim);
    }
}

//// server propagation of firing ////
/*function ServerPlayFiring()
{
    UT3Minigun2v.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
} */

defaultproperties
{

//=============================================================================
// Appearance
//=============================================================================
    AmmoClass=class'UT3MinigunAmmo'
    ProjectileClass=class'UT3StingerShard'
    FlashEmitterClass=class'xEffects.LinkMuzFlashProj1st'
    //SmokeEmitterClass=Class'XEffects.MinigunMuzzleSmoke'

    ProjSpawnOffset=(X=25.000000,Y=5.000000,Z=-6.000000)

//=============================================================================
// Animation
//=============================================================================
     bPawnRapidFireAnim=True
     PreFireAnim="WeaponRampUp"
     FireAnim=
     FireLoopAnim="WeaponFire-Secondary"
     FireEndAnim="WeaponFireEnd"
     //FireEndAnim="WeaponRampDown"
     FireLoopAnimRate=1.800000
     
     /*FireLoopAnimRate=1.800000
     WindUpTime=0.27f
     PreFireTime=0.27f
     TweenTime=0.1f*/
     
//=============================================================================
// Sound
//=============================================================================
     FireSound=Sound'UT3A_Weapon_Stinger.UT3StingerFireAlt.UT3StingerFireAltCue'
     WindingSound=Sound'UT3A_Weapon_Stinger.UT3StingerSingles.UT3StingerBarrelWindLoop01' 
     MinigunSoundVolume=0
     TransientSoundVolume=0.60000

//=============================================================================
// Damage
//=============================================================================
     AmmoPerFire=2
     bSplashDamage=false
     bRecommendSplashDamage=false
     BotRefireRate=0.99
     BarrelRotationsPerSec=1.18 //0.975
     RoundsPerRotation=3
     
     //WindUpTime=0.95
     //PreFireTime=1.3
     TweenTime=0.1
     
     FireForce="minifireb"
     FiringForce="minifireb"
     WindingForce="miniempty"

//=============================================================================
// Camera
//=============================================================================
    /*ShakeOffsetMag=(X=1.0,Y=1.0,Z=1.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2 */
    
}

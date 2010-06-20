//=============================================================================
// UT3AVRiLAltFire.uc
// Imma chargin' mah lazorz!
// 2010, GreatEmerald
//=============================================================================

class UT3AVRiLAltFire extends ONSAVRiLAltFire;

var UT3AVRiLBeam Beam;
var vector EffectOffset;
var float TraceRange;

function DestroyEffects()
{
    if (Beam != None)
        Beam.Destroy();

    Super.DestroyEffects();
}

function PlayFiring()
{
    if (Weapon.AmbientSound != FireSound)
    {
        Weapon.PlayOwnedSound(sound'UT3Weapons2.AVRiL.AvrilBeamStart', SLOT_Interact, TransientSoundVolume);
        Weapon.AmbientSound = FireSound;
    }
}

simulated function bool AllowFire()
{
    if (/*bWaitingForRelease ||*/ Gun == None || !Gun.bLockedOn )//|| PlayerController(Instigator.Controller) == None)
    {
        bWaitingForRelease = true;
        return false;
    }
    else
        return true;

} 

function StopFiring() //GE: Deprecated, using ModeTick instead.
{
    if (Weapon.Role == ROLE_Authority)
    {
        if (Beam != None)
        {
            Beam.Destroy();
            Weapon.AmbientSound = None;
            Weapon.PlayOwnedSound(sound'UT3Weapons2.AVRiL.AvrilBeamStop', SLOT_Interact, TransientSoundVolume);
        }
    }
    Super.StopFiring();
}

simulated function ModeTick(float deltaTime)
{
    local vector HitLocation, HitNormal, StartTrace, /*artTrace,*/ EndTrace, X, Y, Z;
    local rotator Aim;
    local Actor Other;
    //local vector LockTrace;
    //local Actor AlternateTarget;


    if (!bIsFiring)
        return;

    if (!bLosingLock)
    {
        Weapon.GetViewAxes(X,Y,Z);
    
        // the to-hit trace always starts right in front of the eye
        //artTrace = GetBeamStart(X);
        StartTrace = GetBeamStart(X, true);
        
        Aim = AdjustAim(StartTrace, AimError);
        X = Vector(Aim);
        EndTrace = StartTrace + TraceRange * X;
    
        Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
        if (Other == None || Other == Instigator)
            HitLocation = EndTrace;
    
        if (Beam == None)
        {
            if (Weapon.Role == ROLE_Authority)
                Beam = Weapon.spawn(class'UT3AVRiLBeam',,, Instigator.Location);
            else
                foreach Weapon.DynamicActors(class'UT3AVRiLBeam', Beam)
                    break;
        }
    
        if (Beam != None)
            Beam.EndEffect = HitLocation;
    
    }
    else if (Beam != None)
    {
        Beam.Destroy();
        Weapon.AmbientSound = None;
        Weapon.PlayOwnedSound(sound'UT3Weapons2.AVRiL.AvrilBeamStop', SLOT_Interact, TransientSoundVolume);
    } 
    
    Super.ModeTick(DeltaTime);
}

simulated function vector GetBeamStart(vector X, optional bool bArt)
{
    if (Instigator.Controller.Handedness == 2.0 || bArt) //GE: If the player has weapons off (what a fool!), calculate it ourselves
        return Instigator.Location + Instigator.EyePosition() + X*Instigator.CollisionRadius;
    return Weapon.GetBoneCoords('TopArmLock').Origin;
}

defaultproperties
{
    AmmoClass=class'UT3AVRiLAmmo'

    FireSound=Sound'UT3Weapons2.Generic.LaserTracer'
    TransientSoundVolume=1.0
    WarnTargetPct=0.100000
    EffectOffset=(X=-5.000000,Y=15.000000,Z=20.000000)
    TraceRange=10000.000000
}

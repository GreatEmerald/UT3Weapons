//=============================================================================
// UT3RedeemerWarhead.uc
// That's where all the code is.
// 2008, GreatEmerald
//=============================================================================

class UT3RedeemerWarhead extends RedeemerWarhead;

var(Sound) Sound RedeemerExplosionSound;
var(Sound) Sound RedeemerAmbExplosionSound;
var(Sound) Sound RedeemerAmbExplosionSound2;
var(Sound) Sound ShootSound;

simulated function PostNetBeginPlay()
{
    Super(Pawn).PostNetBeginPlay();

    if ( PlayerController(Controller) != None )
    {
        Controller.SetRotation(Rotation);
        PlayerController(Controller).SetViewTarget(self);
        Controller.GotoState(LandMovementState);
        PlayOwnedSound(ShootSound,SLOT_Interact,1.0);
    }
}

state Dying
{
ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

    function Fire( optional float F ) {}
    function BlowUp(vector HitLocation) {}
    function ServerBlowUp() {}
    function Timer() {}
    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                            Vector momentum, class<DamageType> damageType) {}

    function BeginState()
    {
        bHidden = true;
        bStaticScreen = true;
        SetPhysics(PHYS_None);
        SetCollision(false,false,false);
        Spawn(class'IonCore',,, Location, Rotation);
        if ( SmokeTrail != None )
            SmokeTrail.Destroy();
        ShakeView();
    }

    function ShakeView()
    {
        local Controller C;
        local PlayerController PC;
        local float Dist, Scale;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            PC = PlayerController(C);
            if ( PC != None && PC.ViewTarget != None )
            {
                Dist = VSize(Location - PC.ViewTarget.Location);
                if ( Dist < DamageRadius * 2.0)
                {
                    if (Dist < DamageRadius)
                        Scale = 1.0;
                    else
                        Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                    C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
                }
            }
        }
    }

Begin:
    PlaySound(RedeemerExplosionSound, SLOT_Misc);
    HurtRadius(Damage, DamageRadius*0.125, MyDamageType, MomentumTransfer, Location);
    Sleep(0.5);
    HurtRadius(Damage, DamageRadius*0.300, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.475, MyDamageType, MomentumTransfer, Location);
    if (FRand() < 0.5) PlaySound(RedeemerAmbExplosionSound, SLOT_None, 1.0);
    else PlaySound(RedeemerAmbExplosionSound2, SLOT_None, 1.0);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.650, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.825, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*1.000, MyDamageType, MomentumTransfer, Location);
    Destroy();
}

defaultproperties
{
    MomentumTransfer=250000
    MyDamageType=class'DamTypeUT3Redeemer'

    AmbientSound=Sound'UT3A_Weapon_Redeemer.UT3RedeemerSingles.UT3RedeemerFlyLoop02'
    RedeemerExplosionSound=Sound'UT3A_Weapon_Redeemer.UT3RedeemerExplode.UT3RedeemerExplodeCue'
    RedeemerAmbExplosionSound=Sound'UT3A_Weapon_Redeemer.UT3RedeemerSingles.UT3RedeemerExplode01B'
    RedeemerAmbExplosionSound2=Sound'UT3A_Weapon_Redeemer.UT3RedeemerSingles.UT3RedeemerExplode01A'
    ShootSound=Sound'UT3A_Weapon_Redeemer.UT3RedeemerFire.UT3RedeemerFireCue'
    
}

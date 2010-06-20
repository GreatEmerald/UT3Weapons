//=============================================================================
// UT3RedeemerProjectile.uc
// Swallow this!
// 2008, GreatEmerald
//=============================================================================

class UT3RedeemerProjectile extends RedeemerProjectile;

var(Sound) Sound RedeemerExplosionSound;
var(Sound) Sound RedeemerAmbExplosionSound;
var(Sound) Sound RedeemerAmbExplosionSound2;

state Dying
{
    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                            Vector momentum, class<DamageType> damageType) {}
    function Timer() {}

    function BeginState()
    {
        bHidden = true;
        SetPhysics(PHYS_None);
        SetCollision(false,false,false);
        Spawn(class'IonCore',,, Location, Rotation);
        ShakeView();
        InitialState = 'Dying';
        if ( SmokeTrail != None )
            SmokeTrail.Destroy();
        SetTimer(0, false);
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
    MomentumTransfer=250000.000000
    MyDamageType=class'DamTypeUT3Redeemer'

    AmbientSound=Sound'UT3Weapons2.Redeemer.RedeemerAmb'
    RedeemerExplosionSound=Sound'UT3Weapons2.Redeemer.RedeemerExplOld'
    RedeemerAmbExplosionSound=Sound'UT3Weapons2.Redeemer.RedeemerExplo2'
    RedeemerAmbExplosionSound2=Sound'UT3Weapons2.Redeemer.RedeemerExplosion'
    RotationRate=(Roll=0)
    DesiredRotation=(Roll=0)
}

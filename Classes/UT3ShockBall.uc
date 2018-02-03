//==============================================================================
// UT3ShockBall.uc
// You found the Combo class! Hooray! :D
// 2008, GreatEmerald
//==============================================================================

class UT3ShockBall extends ShockProjectile;

var class<DamageType> PrimaryDamageType;

function SuperExplosion()
{
    local actor HitActor;
    local vector HitLocation, HitNormal;

    HurtRadius(ComboDamage, ComboRadius, class'DamTypeUT3ShockCombo', ComboMomentumTransfer, Location );

    Spawn(class'ShockCombo');
    if ( (Level.NetMode != NM_DedicatedServer) && EffectIsRelevant(Location,false) )
    {
        HitActor = Trace(HitLocation, HitNormal,Location - Vect(0,0,120), Location,false);
        if ( HitActor != None )
            Spawn(class'ComboDecal',self,,HitLocation, rotator(vect(0,0,-1)));
    }
    PlaySound(ComboSound, SLOT_None,1.0,,800);
    DestroyTrails();
    Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;

    if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            RefDir = RefNormal;
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        DestroyTrails();
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
        Explode(HitLocation, Normal(HitLocation-Other.Location));
        if ( UT3ShockBall(Other) != None )
            UT3ShockBall(Other).Explode(HitLocation,Normal(Other.Location - HitLocation));
    }
}

State WaitForCombo
{
    function Tick(float DeltaTime)
    {
        if ( (ComboTarget == None) || ComboTarget.bDeleteMe
            || (Instigator == None) || (UT3ShockRifle(Instigator.Weapon) == None) )
        {
            GotoState('');
            return;
        }

        if ( (VSize(ComboTarget.Location - Location) <= 0.5 * ComboRadius + ComboTarget.CollisionRadius)
            || ((Velocity Dot (ComboTarget.Location - Location)) <= 0) )
        {
            UT3ShockRifle(Instigator.Weapon).DoCombo();
            GotoState('');
            return;
        }
    }
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    if (DamageType == PrimaryDamageType)
    {
        Instigator = EventInstigator;
        SuperExplosion();
        if( EventInstigator.Weapon != None )
        {
            EventInstigator.Weapon.ConsumeAmmo(0, ComboAmmoCost, true);
            Instigator = EventInstigator;
        }
    }
}


defaultproperties
{
    Damage=55
    ComboDamage=215
    //ComboRadius=275
    AmbientSound=Sound'UT3A_Weapon_ShockRifle.Singles.AltFireTravel01'
    ImpactSound=Sound'UT3A_Weapon_ShockRifle.AltFireImpact.AltFireImpactCue'
    ComboSound=Sound'UT3A_Weapon_ShockRifle.ComboExplosion.ComboExplosionCue'
    TransientSoundVolume=1.200000
    ComboMomentumTransfer=150000.000000
    DamageRadius=120.000000
    MomentumTransfer=70000.000000
    MyDamageType=class'DamTypeUT3ShockBall'
    ComboDamageType=class'DamTypeUT3ShockCombo'
    PrimaryDamageType=class'DamTypeUT3ShockBeam'

    ComboAmmoCost=3
    LifeSpan=8.000000
}

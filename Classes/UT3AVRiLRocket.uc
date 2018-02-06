//=============================================================================
// UT3AVRiLRocket.uc
// Rockets in the sky.
// 2008, GreatEmerald
//=============================================================================

class UT3AVRiLRocket extends ONSAVRiLRocket;

#EXEC OBJ LOAD FILE=UT3A_Weapon_AVRiL.uax

var() sound ExplosionSound;

simulated function Destroyed()
{
    // Turn of smoke emitters. Emitter should then destroy itself when all particles fade out.
    if ( SmokeTrail != None )
        SmokeTrail.Kill();

    if ( Corona != None )
        Corona.Destroy();

    PlaySound(ExplosionSound,,2.5*TransientSoundVolume); //<-- What were Epic thinking about when applying such hacks!!
    if (!bNoFX && EffectIsRelevant(Location, false))
        spawn(class'ONSAVRiLRocketExplosion',,, Location, rotator(vect(0,0,1)));
    if (Instigator != None && Instigator.IsLocallyControlled() && Instigator.Weapon != None && !Instigator.Weapon.HasAmmo())
        Instigator.Weapon.DoAutoSwitch();
    //hack for crappy weapon firing sound
    //Indeed what a HACK!!! -->
    if (ONSAVRiL(Owner) != None)
        ONSAVRiL(Owner).PlaySound(ExplosionSound, SLOT_Interact, 0.01,, TransientSoundRadius);

    Super(Projectile).Destroyed();
}

defaultproperties
{
    MomentumTransfer=150000.000000
    MyDamageType=class'DamTypeUT3AVRiLRocket'
    ExplosionSound=Sound'UT3A_Weapon_AVRiL.FireImpact.FireImpactCue'
    TransientSoundVolume=0.8
}

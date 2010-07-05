//==============================================================================
// UT3ImpactHammer.uc
// The Impact Hammer!
// 2008, GreatEmerald
//==============================================================================

class UT3ImpactHammer extends ShieldGun;

// TODO: AI rating

simulated function float ChargeBar()
{
    if (FireMode[0].HoldTime >= UT3ImpactHammerFire(FireMode[0]).FullyChargedTime ||
        FireMode[1].HoldTime >= UT3ImpactHammerEMPFire(FireMode[1]).FullyChargedTime)
        Skins[0] = Material'UT3WeaponSkins.ImpactHammer.ImpactHammerActive';
    else
        Skins[0] = default.Skins[0];
    
    if (FireMode[0].bIsFiring)
        return FMin(1,FireMode[0].HoldTime/UT3ImpactHammerFire(FireMode[0]).FullyChargedTime);
    else if (FireMode[1].bIsFiring)
        return FMin(1,FireMode[1].HoldTime/UT3ImpactHammerEMPFire(FireMode[1]).FullyChargedTime);
    return 0;
}

function DoReflectEffect(int Drain)
{
}

simulated function ClientTakeHit(int Drain)
{
}

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int AmmoDrain )
{
return false;
}

function AdjustPlayerDamage( out int Damage, Pawn InstigatedBy, Vector HitLocation,
                                 out Vector Momentum, class<DamageType> DamageType)
{
}

simulated function float AmmoStatus(optional int Mode) // returns float value for ammo amount
{
    return Super(Weapon).AmmoStatus(Mode);
}

function AnimEnd(int channel)
{
    if (FireMode[0].bIsFiring || FireMode[1].bIsFiring)
    {
        LoopAnim('WeaponChargedIdle');
        if (UT3ImpactHammerAttachment(ThirdPersonActor) != None)
            UT3ImpactHammerAttachment(ThirdPersonActor).PlayCharged();
    }
}

function byte BestMode()
{
    local bot B;

    B = Bot(Instigator.Controller);

    if (B == None || B.Enemy == None)
    {
        return 0;
    }
    else if (Vehicle(B.Enemy) != None)
    {
        return 1;
    }
    else if (B.Skill + B.Tactics < 1.0 + 2.0 * FRand())
    {
        return 0;
    }
    return 0;

}

function FireHack(byte Mode)
{
    if ( Mode == 0 )
    {
        FireMode[0].PlayFiring();
        FireMode[0].FlashMuzzleFlash();
        FireMode[0].StartMuzzleSmoke();
        IncrementFlashCount(0);
    }
    else if ( Mode == 1 )
    {
        FireMode[1].PlayFiring();
        FireMode[1].FlashMuzzleFlash();
        FireMode[1].StartMuzzleSmoke();
        IncrementFlashCount(1);
    }
}

function float GetAIRating()
{
    local Bot B;
    local float EnemyDist;

    B = Bot(Instigator.Controller);
    if (B == None)
    {
        return AIRating;
    }
    // super desireable for bot waiting to impact jump
    if (B.bPreparingMove && B.ImpactTarget != None)
    {
        return 9.f;
    }

    if (B.Enemy == None)
    {
        return AIRating;
    }

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if (B.Stopped() && EnemyDist > 100.f)
    {
        return 0.1;
    }
    if (EnemyDist < 750.f && B.Skill <= 2 && UT3ImpactHammer(B.Enemy.Weapon) != None)
    {
        return FClamp(300.f / (EnemyDist + 1.f), 0.6, 0.75);
    }
    if (EnemyDist > 400)
    {
        return 0.1;
    }
    if (Instigator.Weapon != self && EnemyDist < 120)
    {
        return 0.25;
    }
    return FMin(0.6, 90.f / (EnemyDist + 1.f));
}

defaultproperties
{
     FireModeClass(0)=Class'UT3Style.UT3ImpactHammerFire'
     FireModeClass(1)=Class'UT3Style.UT3ImpactHammerEMPFire'
     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     BringUpTime=0.513300
     SelectSound=Sound'UT3Weapons.ImpactHammer.ImpactHammerTakeOut'
     Description="The Impact Hammer, originally designed for sub-surface drift mining, can focus several hundred metric tons of pressure into the space of a few square centimeters. The impact, and resulting shock wave, easily destabilizes solid stone to speed ore separation and excavation. After several mining accidents highlighted the Hammer's devastating effect on the human body, the N.E.G. military took interest. To improve the Hammer's effectiveness against vehicles with shock-absorbing armor, an alternate electromagnetic pulse (EMP) mode was added. The EMP violently scrambles onboard computer systems, quickly leading to engine failure. Field testing showed the EMP has a similar effect on infantry powerups, knocking them off soldiers and enabling battlefield recovery."
     HudColor=(B=128,G=255)
     SmallViewOffset=(X=15.000000,Y=6.000000,Z=-5.000000)
     CustomCrossHairColor=(B=128,G=255)
     CustomCrossHairScale=1.500000
     CustomCrossHairTextureName="UT3HUD.Crosshairs.UT3CrosshairImpactHammer"
     PickupClass=Class'UT3Style.UT3ImpactHammerPickup'
     PlayerViewPivot=(Pitch=2000,Yaw=-1000)
     AttachmentClass=Class'UT3Style.UT3ImpactHammerAttachment'
     IconMaterial=TexScaler'UT3HUD.Icons.UT3IconsScaled'
     IconCoords=(X1=226,Y1=162,X2=294,Y2=191)
     ItemName="UT3 Impact Hammer"
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Impact_1P'
     Skins(0)=Shader'UT3WeaponSkins.ImpactHammer.ImpactHammerSkin'
     HighDetailOverlay=None
}

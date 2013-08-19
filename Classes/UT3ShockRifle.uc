//==============================================================================
// UT3ShockRifle.uc
// Shocking.
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3ShockRifle extends ShockRifle;

/*var const Material RedSkin, BlueSkin;

simulated function ApplySkin()
{
    local Controller Contra;
    local UT3ShockRifleAttachment Tach;
    
    if (Instigator.Controller != None)
        Contra = Instigator.Controller;
    else
        return;
    
    Tach = UT3ShockRifleAttachment(ThirdPersonActor);
    if ( (Contra != None) && (Contra.PlayerReplicationInfo != None)&& (Contra.PlayerReplicationInfo.Team != None) )
    {
        if ( Contra.PlayerReplicationInfo.Team.TeamIndex == 0 )
        {
            Skins[0] = RedSkin;
            if (Tach != None)
                Tach.Skins[0] = RedSkin;
        }
        else if ( Contra.PlayerReplicationInfo.Team.TeamIndex == 1 )
        {
            Skins[0] = BlueSkin;
            if (Tach != None)
                Tach.Skins[0] = BlueSkin; 
        }
        //log("UT3ShockRifle: Tach skin is"@Tach.Skins[0]);
    }
}

function AttachToPawn(Pawn P)
{
    Super.AttachToPawn(P);
    ApplySkin(); //GE: Applying skin here instead of PostBeginPlay() since we don't have the Instigator nor attachment there yet... We get Instigator on GiveTo, Attachment here.
}*/

function byte BestMode()
{
    local float EnemyDist, MaxDist;
    local bot B;

    bWaitForCombo = false;
    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return 0;

    if (B.IsShootingObjective())
        return 0;

    if ( !B.EnemyVisible() )
    {
        if ( (ComboTarget != None) && !ComboTarget.bDeleteMe && B.CanCombo() )
        {
            bWaitForCombo = true;
            return 0;
        }
        ComboTarget = None;
        if ( B.CanCombo() && B.ProficientWithWeapon() )
        {
            bRegisterTarget = true;
            return 1;
        }
        return 0;
    }

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if ( B.Skill > 5 )
        MaxDist = 4 * class'UT3ShockBall'.default.Speed; //GE: Added just to change this. It doesn't really matter since it's the same as in ShockProjectile.
    else
        MaxDist = 3 * class'UT3ShockBall'.default.Speed;

    if ( (EnemyDist > MaxDist) || (EnemyDist < 150) )
    {
        ComboTarget = None;
        return 0;
    }

    if ( (ComboTarget != None) && !ComboTarget.bDeleteMe && B.CanCombo() )
    {
        bWaitForCombo = true;
        return 0;
    }

    ComboTarget = None;

    if ( (EnemyDist > 2500) && (FRand() < 0.5) )
        return 0;

    if ( B.CanCombo() && B.ProficientWithWeapon() )
    {
        bRegisterTarget = true;
        return 1;
    }
    if ( FRand() < 0.7 )
        return 0;
    return 1;
}

defaultproperties
{
    ItemName="UT3 Shock Rifle"
    Description="The ASMD Shock Rifle has changed little since its first incorporation into the Liandri Tournament. The ASMD sports two firing modes: a thin photon beam, and a sphere of unstable plasma energy. These modes are each deadly in their own right, but used together they can neutralize opponents in a devastating shockwave. The energy spheres can be detonated with the photon beam, releasing the explosive energy of the anti-photons in the plasma's EM containment field."

    FireModeClass(0)=UT3ShockFire
    FireModeClass(1)=UT3ShockAltFire

    PickupClass=class'UT3ShockRiflePickup'
    AttachmentClass=class'UT3ShockRifleAttachment'

    SelectSound=Sound'UT3Weapons.ShockRifle.ShockRifleTakeOut'
    TransientSoundVolume=1.0

    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairShockRifle"
	CustomCrosshairColor=(B=255,G=0,R=160,A=255)
	HudColor=(B=255,G=0,R=160,A=255)
	CustomCrosshairScale=1.00

	IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=363,Y1=190,X2=445,Y2=213)
    bSniping=True

    Priority=4.200000
   AIRating=0.650000
   
     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     PlayerViewPivot=(Pitch=0,Yaw=-15884,Roll=500)
     SmallViewOffset=(X=24,Y=11.5,Z=-9.5)
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_ShockRifle_1P'
     BringUpTime=0.367
     PutDownTime=0.367
     HighDetailOverlay=None
     Skins(0)=Shader'UT3WeaponSkins.ShockRifle.ShockRifleSkin'
}


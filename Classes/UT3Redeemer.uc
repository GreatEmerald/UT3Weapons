//=============================================================================
// UT3Redeemer.uc
// Denied!
// 2008, 2013 GreatEmerald
//=============================================================================

class UT3Redeemer extends Redeemer;

/*
    AttachToPawn mod needed since if you attach it to the right hand, the
    cumbersome thing will clip right through the person's body. Quite
    funny to look at, but not what's intended. -GE
*/

function AttachToPawn(Pawn P)
{
    local name BoneName;

    Instigator = P;
    if ( ThirdPersonActor == None )
    {
        ThirdPersonActor = Spawn(AttachmentClass,Owner);
        InventoryAttachment(ThirdPersonActor).InitFor(self);
    }
    else
        ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
    BoneName = P.GetOffHandBoneFor(self);
    if ( BoneName == '' )
    {
        ThirdPersonActor.SetLocation(P.Location);
        ThirdPersonActor.SetBase(P);
    }
    else
        P.AttachToBone(ThirdPersonActor,BoneName);
}

simulated function BringUp(optional Weapon PrevWeapon) //GE: cast BringUp and PutDown to the attachment class
{
    if (UT3RedeemerAttachment(ThirdPersonActor) != None)
        UT3RedeemerAttachment(ThirdPersonActor).BringUp();
    Super.BringUp();
}

simulated function bool PutDown()
{
    if (UT3RedeemerAttachment(ThirdPersonActor) != None)
        UT3RedeemerAttachment(ThirdPersonActor).PutDown();
    return Super.PutDown();
}

defaultproperties
{
    FireModeClass(0)=UT3RedeemerFire
    FireModeClass(1)=UT3RedeemerGuidedFire
    AttachmentClass=class'UT3RedeemerAttachment'
    ItemName="UT3 Redeemer"
    Description="'Even your least effective soldiers will earn a respectable bodycount with this tactical nuclear device.' So said the original brochure for the Redeemer, still unchallenged in its role as the most powerful man-portable weapon system known through the galaxy.|The slow-moving but utterly devastating missile, affectionately known as 'Lola' by veteran soldiers, now uses an Enhanced Radiation payload. This ensures maximum tissue failure without undue property damage, perfect for modern assault-and-capture tactics.|The Redeemer's alternate mode fires the missile using the disposable fly-by-wire guidance system, though the manual recommends using this mode only in areas of relative safety."
    PickupClass=class'UT3RedeemerPickup'
    SelectSound=Sound'UT3Weapons2.Redeemer.RedeemerTakeOut'
    TransientSoundVolume=0.45
    IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=227,Y1=191,X2=299,Y2=233)
    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairRedeemer"
	CustomCrosshairColor=(B=0,G=0,R=255,A=255)
	HudColor=(B=0,G=0,R=255,A=255)
	CustomCrosshairScale=2.0
	
     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     SelectAnimRate=1.000000
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Redeemer_1P'
     BringUpTime=2.1
     PutDownTime=0.97
     SmallViewOffset=(X=-8.0,Y=0.0,Z=-16.0)
     PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
     BobDamping=2.2
}

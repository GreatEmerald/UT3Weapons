//=============================================================================
// UT3Redeemer.uc
// Denied!
// 2008, GreatEmerald
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
     FireModeClass(0)=Class'UT3Style.UT3RedeemerFire'
     FireModeClass(1)=Class'UT3Style.UT3RedeemerGuidedFire'
     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     SelectAnimRate=1.000000
     PutDownTime=0.970000
     BringUpTime=2.100000
     SelectSound=Sound'UT3Weapons2.Redeemer.RedeemerTakeOut'
     Description="'Even your least effective soldiers will earn a respectable bodycount with this tactical nuclear device.' So said the original brochure for the Redeemer, still unchallenged in its role as the most powerful man-portable weapon system known through the galaxy.|The slow-moving but utterly devastating missile, affectionately known as 'Lola' by veteran soldiers, now uses an Enhanced Radiation payload. This ensures maximum tissue failure without undue property damage, perfect for modern assault-and-capture tactics.|The Redeemer's alternate mode fires the missile using the disposable fly-by-wire guidance system, though the manual recommends using this mode only in areas of relative safety."
     HudColor=(G=0)
     SmallViewOffset=(X=-6.000000,Y=1.500000,Z=-17.000000)
     CustomCrossHairColor=(B=0,G=0)
     CustomCrossHairTextureName="UT3HUD.Crosshairs.UT3CrosshairRedeemer"
     PickupClass=Class'UT3Style.UT3RedeemerPickup'
     BobDamping=2.200000
     AttachmentClass=Class'UT3Style.UT3RedeemerAttachment'
     IconMaterial=TexScaler'UT3HUD.Icons.UT3IconsScaled'
     IconCoords=(X1=227,Y1=191,X2=299,Y2=233)
     ItemName="UT3 Redeemer"
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Redeemer_1P'
     TransientSoundVolume=0.450000
}

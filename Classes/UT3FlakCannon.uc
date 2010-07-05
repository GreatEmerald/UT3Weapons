//==============================================================================
// UT3FlakCannon.uc
// Flak Monkey.
// 2008, GreatEmerald
//==============================================================================

class UT3FlakCannon extends FlakCannon;

defaultproperties
{
     FireModeClass(0)=Class'UT3Style.UT3FlakFire'
     FireModeClass(1)=Class'UT3Style.UT3FlakAltFire'
     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     SelectSound=Sound'UT3Weapons.FlakCannon.FlakCannonTakeOut'
     OldPlayerViewOffset=(Y=7.000000)
     Description="Trident Defensive Technologies continues to tweak and refine the flak cannon with their newly released Mk4 'Peacekeeper.' In spite of its new name, the flak cannon remains banned from most military conflicts for high incidences of maiming and collateral damage. Still, the flak cannon is the weapon of choice for unconventional warfare in urban terrain. The primary mode detonates the flak shell in the barrel, launching shrapnel forward in a deadly shotgun pattern but often deafening the operator. The cannon also lobs an explosive flak shell that detonates on contact, sending shrapnel in a dangerously wide and unpredictable radius."
     HudColor=(B=128,G=255)
     SmallViewOffset=(X=18.000000,Y=25.000000,Z=-10.000000)
     CustomCrossHairColor=(B=128,G=255)
     CustomCrossHairScale=1.500000
     CustomCrossHairTextureName="UT3HUD.Crosshairs.UT3CrosshairFlakCannon"
     PickupClass=Class'UT3Style.UT3FlakCannonPickup'
     PlayerViewPivot=(Pitch=800,Yaw=-500,Roll=0)
     AttachmentClass=Class'UT3Style.UT3FlakAttachment'
     IconMaterial=TexScaler'UT3HUD.Icons.UT3IconsScaled'
     IconCoords=(X1=65,Y1=214,X2=131,Y2=240)
     ItemName="UT3 Flak Cannon"
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_FlakCannon_1P'
     HighDetailOverlay=None
}

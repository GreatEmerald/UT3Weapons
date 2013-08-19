//==============================================================================
// UT3FlakCannon.uc
// Flak Monkey.
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3FlakCannon extends FlakCannon;

defaultproperties
{
    ItemName="UT3 Flak Cannon"
    Description="Trident Defensive Technologies continues to tweak and refine the flak cannon with their newly released Mk4 'Peacekeeper.' In spite of its new name, the flak cannon remains banned from most military conflicts for high incidences of maiming and collateral damage. Still, the flak cannon is the weapon of choice for unconventional warfare in urban terrain. The primary mode detonates the flak shell in the barrel, launching shrapnel forward in a deadly shotgun pattern but often deafening the operator. The cannon also lobs an explosive flak shell that detonates on contact, sending shrapnel in a dangerously wide and unpredictable radius."
    FireModeClass(0)=UT3FlakFire
    FireModeClass(1)=UT3FlakAltFire
    PickupClass=class'UT3FlakCannonPickup'
    SelectSound=Sound'UT3Weapons.FlakCannon.FlakCannonTakeOut'
   	CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairFlakCannon"
	CustomCrosshairColor=(B=128,G=255,R=255,A=255)
	CustomCrosshairScale=1.5
	HudColor=(B=128,G=255,R=255,A=255)

	IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=65,Y1=214,X2=131,Y2=240)
    
     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     //OldPlayerViewOffset=(Y=7.000000)
     PlayerViewPivot=(Yaw=-250,Pitch=500,Roll=0)
     PlayerViewOffset=(X=-10.0,Y=10.0,Z=-5.0)
     SmallViewOffset=(X=12,Y=20,Z=-13)
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_FlakCannon_1P'
     AttachmentClass=class'UT3FlakAttachment'
     HighDetailOverlay=None
}

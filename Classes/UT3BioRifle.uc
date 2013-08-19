//==============================================================================
// UT3BioRifle.uc
// Biohazard!
// 2008, 2013 GreatEmerald
//==============================================================================

class UT3BioRifle extends BioRifle;

simulated function AnimEnd(int Channel)
{
    local name anim;
    local float frame, rate;
    GetAnimParams(0, anim, frame, rate);

    if (anim == 'AltFire')
        LoopAnim('WeaponAltIdle', 1.0, 1.0);
    else
        Super.AnimEnd(Channel);
}

defaultproperties
{
    ItemName="UT3 Bio Rifle"
    Description="The GES BioRifle processes Tarydium from its stable crystalline form into a reactive mutagenic sludge. It can rapidly disperse these toxins for wide-area coverage, or fire a virulent payload of variable, but usually lethal, capacity. In layman's terms, this means the BioRifle can pepper an area with small globs of biosludge, or launch one noxious glob at the target. The BioRifle's ability to carpet an area with a toxic minefield makes it a notoriously effective defensive weapon."

    FireModeClass(0)=UT3BioFire
    FireModeClass(1)=UT3BioChargedFire
    PickupClass=class'UT3BioRiflePickup'
    SelectSound=Sound'UT3Weapons2.BioRifle.BioRifleTakeOut'
    TransientSoundVolume=0.92

    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairBioRifle"
	CustomCrosshairColor=(B=64,G=255,R=64,A=255)
	HudColor=(B=64,G=255,R=64,A=255)
	CustomCrosshairScale=1.5

	IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=300,Y1=200,X2=363,Y2=229)
    
     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     SelectAnimRate=1.000000
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_BioRifle_1P'
      IdleAnimRate=0.8
      RestAnimRate=0.8
      RunAnimRate=0.8
      AimAnimRate=0.8
      
      DrawScale=0.9
      PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
      PlayerViewOffset=(X=4.0,Y=2.0,Z=0.0)
      SmallViewOffset=(X=15,Y=6,Z=-4)
     
     UV2Mode=UVM_LightMap
     AttachmentClass=class'UT3BioAttachment'
}

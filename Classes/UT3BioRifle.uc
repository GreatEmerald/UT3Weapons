//==============================================================================
// UT3BioRifle.uc
// Biohazard!
// 2008, GreatEmerald
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
     FireModeClass(0)=Class'UT3Style.UT3BioFire'
     FireModeClass(1)=Class'UT3Style.UT3BioChargedFire'
     IdleAnim="WeaponIdle"
     RestAnim="WeaponIdle"
     AimAnim="WeaponIdle"
     RunAnim="WeaponIdle"
     SelectAnim="WeaponEquip"
     PutDownAnim="WeaponPutDown"
     IdleAnimRate=0.800000
     RestAnimRate=0.800000
     AimAnimRate=0.800000
     RunAnimRate=0.800000
     SelectAnimRate=1.000000
     SelectSound=Sound'UT3Weapons2.BioRifle.BioRifleTakeOut'
     Description="The GES BioRifle processes Tarydium from its stable crystalline form into a reactive mutagenic sludge. It can rapidly disperse these toxins for wide-area coverage, or fire a virulent payload of variable, but usually lethal, capacity. In layman's terms, this means the BioRifle can pepper an area with small globs of biosludge, or launch one noxious glob at the target. The BioRifle's ability to carpet an area with a toxic minefield makes it a notoriously effective defensive weapon."
     HudColor=(B=64,G=255,R=64)
     CustomCrossHairColor=(B=64,G=255,R=64)
     CustomCrossHairScale=1.500000
     CustomCrossHairTextureName="UT3HUD.Crosshairs.UT3CrosshairBioRifle"
     PickupClass=Class'UT3Style.UT3BioRiflePickup'
     PlayerViewPivot=(Pitch=1000,Yaw=-500)
     AttachmentClass=Class'UT3Style.UT3BioAttachment'
     IconMaterial=TexScaler'UT3HUD.Icons.UT3IconsScaled'
     IconCoords=(X1=300,Y1=200,X2=363,Y2=229)
     ItemName="UT3 Bio Rifle"
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_BioRifle_1P'
     DrawScale=0.900000
     UV2Mode=UVM_LightMap
     TransientSoundVolume=0.920000
}

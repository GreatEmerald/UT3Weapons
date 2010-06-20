//=============================================================================
// UT3AVRiLPickup.uc
// Wow, a Longbow, in the 24th century?
// 2008, GreatEmerald
//=============================================================================

class UT3AVRiLPickup extends ONSAVRiLPickup;

DefaultProperties
{
    InventoryType=class'UT3AVRIL'
    PickupMessage="Longbow AVRiL"
    PickupSound=Sound'UT3PickupSounds.Generic.AVRILPickup'
    TransientSoundVolume=0.6
    
    StaticMesh=StaticMesh'UT3WPStatics.UT3AVRiLPickup'
    PrePivot=(Y=25)
    DrawScale=1.2
    Skins(0)=Shader'UT3WeaponSkins.AVRiL.AVRiLSkin'
    Skins(1)=Shader'UT3WeaponSkins.AVRiL.AVRiLProjSkin'
    StandUp=(X=0.25,Y=0.0,Z=0.25)
}

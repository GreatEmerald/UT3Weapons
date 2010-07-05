//=============================================================================
// UT3AVRiLPickup.uc
// Wow, a Longbow, in the 24th century?
// 2008, GreatEmerald
//=============================================================================

class UT3AVRiLPickup extends ONSAVRiLPickup;

defaultproperties
{
     StandUp=(X=0.250000,Y=0.000000,Z=0.250000)
     InventoryType=Class'UT3Style.UT3AVRIL'
     PickupMessage="Longbow AVRiL"
     PickupSound=Sound'UT3PickupSounds.Generic.AVRILPickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3AVRiLPickup'
     DrawScale=1.200000
     PrePivot=(Y=25.000000)
     Skins(0)=Shader'UT3WeaponSkins.AVRiL.AVRiLSkin'
     Skins(1)=Shader'UT3WeaponSkins.AVRiL.AVRiLProjSkin'
     TransientSoundVolume=0.600000
}

/******************************************************************************
UT3LinkGunPickup

Creation date: 2008-07-17 11:16
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3LinkGunPickup extends LinkGunPickup;


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     StandUp=(X=0.250000,Y=0.000000,Z=0.250000)
     InventoryType=Class'UT3Style.UT3LinkGun'
     PickupMessage="Link Gun"
     PickupSound=Sound'UT3PickupSounds.Generic.LinkGunPickup'
     StaticMesh=StaticMesh'UT3WPStatics.UT3LinkGunPickup'
     DrawScale=1.100000
     PrePivot=(Y=24.000000)
     Skins(0)=Shader'UT3WeaponSkins.LinkGun.LinkGunSkin'
}

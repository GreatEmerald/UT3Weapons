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
  	InventoryType = class'UT3LinkGun'
  	PickupSound=Sound'UT3PickupSounds.LinkGunPickup'
  	Skins(0)=Shader'UT3WeaponSkins.LinkGun.LinkGunSkin'
  	PickupMessage="Link Gun"
    StaticMesh=StaticMesh'UT3WPStatics.UT3LinkGunPickup'
    PrePivot=(Y=24)
    DrawScale=1.1
    StandUp=(X=0.25,Y=0.0,Z=0.25)
}

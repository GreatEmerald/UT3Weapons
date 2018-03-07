/******************************************************************************
UT3Crosshairs

Creation date: 2008-07-15 12:23
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3Crosshairs extends CrosshairPack;


//=============================================================================
// Imports
//=============================================================================

#exec obj load file=UT3HUD.utx


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	Crosshair(0)  = (FriendlyName="UT3 Default",CrosshairTexture=Texture'UT3CrosshairDefault')
	Crosshair(1)  = (FriendlyName="UT3 Impact Hammer",CrosshairTexture=Texture'UT3CrosshairImpactHammer')
	Crosshair(2)  = (FriendlyName="UT3 Enforcer",CrosshairTexture=Texture'UT3CrosshairEnforcer')
	Crosshair(3)  = (FriendlyName="UT3 Bio Rifle",CrosshairTexture=Texture'UT3CrosshairBioRifle')
	Crosshair(4)  = (FriendlyName="UT3 Shock Rifle",CrosshairTexture=Texture'UT3CrosshairShockRifle')
	Crosshair(5)  = (FriendlyName="UT3 Link Gun",CrosshairTexture=Texture'UT3CrosshairLinkGun')
	Crosshair(6)  = (FriendlyName="UT3 Stinger",CrosshairTexture=Texture'UT3CrosshairStinger')
	Crosshair(7)  = (FriendlyName="UT3 Flak Cannon",CrosshairTexture=Texture'UT3CrosshairFlakCannon')
	Crosshair(8)  = (FriendlyName="UT3 Rocket Launcher (0)",CrosshairTexture=Texture'UT3CrosshairRocketLauncher')
	Crosshair(9)  = (FriendlyName="UT3 Rocket Launcher (1)",CrosshairTexture=Texture'UT3CrosshairRocketLauncher1')
	Crosshair(10) = (FriendlyName="UT3 Rocket Launcher (2)",CrosshairTexture=Texture'UT3CrosshairRocketLauncher2')
	Crosshair(11) = (FriendlyName="UT3 Rocket Launcher (3)",CrosshairTexture=Texture'UT3CrosshairRocketLauncher3')
	Crosshair(12) = (FriendlyName="UT3 AVRiL",CrosshairTexture=Texture'UT3CrosshairAVRiL')
	Crosshair(13) = (FriendlyName="UT3 Sniper Rifle",CrosshairTexture=Texture'UT3CrosshairSniperRifle')
	Crosshair(14) = (FriendlyName="UT3 Redeemer",CrosshairTexture=Texture'UT3CrosshairRedeemer')
	Crosshair(15) = (FriendlyName="UT3 InstaGib",CrosshairTexture=Texture'UT3CrosshairInstaGib')
	Crosshair(16)=(FriendlyName="UT3 Translocator",CrosshairTexture=Texture'UT3HUD.Crosshairs.UT3CrosshairTranslocator')
}

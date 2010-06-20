/******************************************************************************
UT3Powerup

Creation date: 2008-07-15 11:05
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3Powerup extends Inventory abstract;


simulated function BeginPlay()
{
	local PlayerController LocalPlayer;
	local int i;
	
	if (Level.NetMode != NM_DedicatedServer) {
		LocalPlayer = Level.GetLocalPlayerController();
		if (LocalPlayer != None && LocalPlayer.MyHud != None) {
			for (i = 0; i < LocalPlayer.MyHud.Overlays.Length; ++i) {
				if (UT3HudOverlay(LocalPlayer.MyHud.Overlays[i]) != None)
					return;
			}
			LocalPlayer.MyHud.AddHudOverlay(Spawn(class'UT3HudOverlay'));
		}
	}
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
}

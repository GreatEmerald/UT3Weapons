/******************************************************************************
UT3TranslocatorEffect

Creation date: 2008-07-14 14:45
Last change: $Id$
Copyright (c) 2008, 2013 Wormbo, GreatEmerald
******************************************************************************/

class UT3TranslocatorEffect extends Emitter abstract;


//=============================================================================
// Imports
//=============================================================================

#exec obj load file=EpicParticles.utx
#exec obj load file=ParticleMeshes.usx
#exec obj load file=UT3A_Weapon_Translocator.uax


//=============================================================================
// Properties
//=============================================================================

var vector FlashColor;
var float FlashScale;


function PostBeginPlay()
{
	if (Role == ROLE_Authority)
		Instigator = Pawn(Owner);
	if (Level.NetMode == NM_DedicatedServer)
		LifeSpan = 0.15;
	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	local float Dist;

	if (Instigator != None) {
		SetLocation(Instigator.Location);
		SetBase(Instigator);
		if (PlayerController(Instigator.Controller) != None && !PlayerController(Instigator.Controller).bBehindView ) {
			/*Emitters[0].InitialParticlesPerSecond *= 0.5;
			Emitters[0].SphereRadiusRange.Min *= 2.4;
			Emitters[0].SphereRadiusRange.Max *= 2.4;
			Emitters[1].Disabled = true;*/
			if (Viewport(PlayerController(Instigator.Controller).Player) != None) {
				PlayerController(Instigator.Controller).ClientFlash(FlashScale, FlashColor);
			}
		}
		else if (Level.NetMode == NM_Standalone || Level.NetMode == NM_Client) {
			PC = Level.GetLocalPlayerController();
			if (PC != None && PC.ViewTarget != None) {
				Dist = VSize(PC.ViewTarget.Location - Location);
				if (Dist > PC.Region.Zone.DistanceFogEnd)
					LifeSpan = 0.01;
				else if (Dist > 8000)
					Emitters[1].Disabled = true;
			}
		}
	}
	PlaySound(Sound'UT3Translocator.TranslocatorTeleport', SLOT_None, 1.0);
	Super.PostNetBeginPlay();
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	bReplicateInstigator = true
	RemoteRole           = ROLE_SimulatedProxy
	bNetTemporary        = true
	bNoDelete            = false
	AutoDestroy          = true

	TransientSoundRadius = 500.0 //1000 is probably too much, still experimenting
        TeleportSound=Sound'UT3A_Weapon_Translocator.UT3TransTeleport.UT3TransTeleportCue'

	FlashScale = 0.7
}

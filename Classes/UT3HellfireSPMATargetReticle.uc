/******************************************************************************
UT3HellfireSPMATargetReticle

Creation date: 2009-02-17 15:58
Latest change: $Id$
Copyright (c) 2009, Wormbo
******************************************************************************/

class UT3HellfireSPMATargetReticle extends ONSMortarTargetBeam;


//=============================================================================
// Imports
//=============================================================================

#exec obj load file=UT3SPMAReticle.usx package=UT3Style.SPMAReticle


//=============================================================================
// Properties
//=============================================================================

var float ReachableInitScale, ReachableScale, UnreachableScale;
var StaticMesh ReachableMesh, UnreachableMesh;


// controlled directly by camera
function Tick(float DeltaTime)
{
	// TODO: draw arc here?
}


function SetStatus(bool bActivated)
{
	if (bReticleActivated != bActivated) {
		bReticleActivated = bActivated;
		if (bReticleActivated) {
			SetTimer(0.3, false);
			SetStaticMesh(ReachableMesh);
			SetDrawScale(ReachableInitScale);
		}
		else {
			SetTimer(0.0, false);
			SetStaticMesh(UnreachableMesh);
			SetDrawScale(UnreachableScale);
		}
	}
}


function Timer()
{
	SetDrawScale(ReachableScale);
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     ReachableInitScale=1.250000
     ReachableScale=1.000000
     UnreachableScale=0.800000
     ReachableMesh=StaticMesh'UT3Style.SPMAReticle.SPMAReticleLock'
     UnreachableMesh=StaticMesh'UT3Style.SPMAReticle.SPMAReticle'
     bReticleActivated=False
     StaticMesh=StaticMesh'UT3Style.SPMAReticle.SPMAReticle'
     DrawScale3D=(X=1.000000,Y=1.000000,Z=1.000000)
}

/******************************************************************************
UT3LeviathanBolt

Creation date: 2007-12-30 18:58
Last change: $Id$
Copyright (c) 2007, Wormbo
******************************************************************************/

class UT3LeviathanBolt extends ONSMASRocketProjectile;


var float AccelRate;


simulated function PostNetBeginPlay()
{
	Acceleration = AccelRate * Normal(Velocity);
}


function Timer();


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     AccelRate=20000.000000
     Speed=1200.000000
     MaxSpeed=3500.000000
     Damage=100.000000
     DamageRadius=300.000000
     MomentumTransfer=4000.000000
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
}

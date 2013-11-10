/******************************************************************************
UT3LinkGunAttachment

Creation date: 2008-07-17 11:15
Last change: $Id$
Copyright (c) 2008, 2013 Wormbo, GreatEmerald
******************************************************************************/

class UT3LinkGunAttachment extends LinkAttachment;

// GEm: FIXME: It would be nice to have a mesh that *does* have a beam tip bone!
/*simulated function Vector GetTipLocation()
{
    local Coords C;
    C = GetBoneCoords('beamtip');
    return C.Origin;
}*/

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_LinkGun_3P'
    RelativeRotation=(Yaw=16384)
    DrawScale=0.8
    RelativeLocation=(X=5,Y=-2,Z=2)
}

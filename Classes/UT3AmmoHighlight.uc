//=============================================================================
// UT3AmmoHighlight.uc
// The overlay effect helper class for the ammo pickups
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3AmmoHighlight extends StaticMeshActor
    notplaceable;

defaultproperties
{
    bCollideActors = false
    bCollideWorld = false
    bWorldGeometry = false
    bStatic = false
    bNotOnDedServer = true
    RemoteRole = ROLE_None
}

//=============================================================================
// UT3DecorativeMesh.uc
// A class for spawnable, client-side decorative static meshes
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3DecorativeMesh extends StaticMeshActor
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

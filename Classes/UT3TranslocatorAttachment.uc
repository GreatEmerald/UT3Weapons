//=============================================================================
// UT3SniperAttachment.uc
// Transcendential locator?..
// 2010, GreatEmerald
//=============================================================================

class UT3TranslocatorAttachment extends TransAttachment;

simulated event BaseChange()
{
    if ( (Pawn(Base) != None) && (Pawn(Base).PlayerReplicationInfo != None) && (Pawn(Base).PlayerReplicationInfo.Team != None) )
    {
        if ( Pawn(Base).PlayerReplicationInfo.Team.TeamIndex == 1 )
        {
            Skins[0] = Material'UT3WeaponSkins.Translocator.TranslocatorSkinBlue';
            Skins[1] = Material'UT3WeaponSkins.Translocator.TranslocatorSkinBlue';
        }
        else
        {
            Skins[0] = Material'UT3WeaponSkins.Translocator.TranslocatorSkinRed';
            Skins[1] = Material'UT3WeaponSkins.Translocator.TranslocatorSkinRed';
        }
    }
}

function InitFor(Inventory I)
{
    LoopAnim('WeaponIdle', , 0.0);
    Super.InitFor(I);
}

defaultproperties
{
	   Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_Translocator_3P_Mid'
     RelativeLocation=(X=0,Y=-2,Z=1)
     RelativeRotation=(Pitch=32768,Yaw=16384)
     DrawScale=0.85
     Skins(0)=Material'UT3WeaponSkins.Translocator.TranslocatorSkinRed'
     Skins(1)=Material'UT3WeaponSkins.Translocator.TranslocatorSkinRed'
}

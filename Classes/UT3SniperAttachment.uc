//=============================================================================
// UT3SniperAttachment.uc
// Seagoat. That's the only place they grow, little bastards.
// 2008, GreatEmerald
//=============================================================================

class UT3SniperAttachment extends ClassicSniperAttachment;

var class<xEmitter> mMuzFlash3rdClass;

simulated event ThirdPersonEffects()
{
    //local vector SmokeLoc, SmokeOffset;
    //local coords    C;

    if ( (FlashCount != 0) && (Level.NetMode != NM_DedicatedServer) )
    {
        if (FiringMode == 0)
        {
            WeaponLight();

            if ( Level.TimeSeconds - Instigator.LastRenderTime < 0.2 )
            {
                if (mMuzFlash3rd == None)
                {
                    mMuzFlash3rd = Spawn(mMuzFlash3rdClass);
                    //log("UT3SniperAttachment: Muzzle Flash is"@mMuzFlash3rd);
                }
                if (mMuzFlash3rd != None)
                {
                    AttachToBone(mMuzFlash3rd, 'tip');
                    mMuzFlash3rd.mStartParticles++;
                }
                /*if (mMuzFlash3rd == None)
                    mMuzFlash3rd = Spawn(mMuzFlash3rdClass);
                
                C = Instigator.Weapon.GetBoneCoords('tip');
    
                if (mMuzFlash3rd != None)
                {
                    mMuzFlash3rd.SetLocation( C.Origin );//.Origin + SmokeOffset + C.ZAxis * 23 + C.YAxis*4.5);
                    mMuzFlash3rd.SetDrawScale(1.0);
                    mMuzFlash3rd.SetRotation(rotator(-1 * C.ZAxis));
                    mMuzFlash3rd.mStartParticles++; 
                } */
            }
        }
     }

    Super(xWeaponAttachment).ThirdPersonEffects();
}

defaultproperties
{
     mMuzFlash3rdClass=Class'XEffects.AssaultMuzFlash3rd'
     Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_SniperRifle_3P_Mid'
     RelativeLocation=(X=0.000000,Y=-2.000000,Z=1.000000)
     RelativeRotation=(Yaw=16384)
     DrawScale=0.900000
     Skins(0)=Texture'UT3WeaponSkins.T_WP_SniperRifle_D'
     HighDetailOverlay=Shader'UT3WeaponSkins.SniperRifle.SniperRifleSkinRed'
}

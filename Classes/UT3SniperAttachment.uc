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
  
     HighDetailOverlay=Shader'UT3WeaponSkins.SniperRifle.SniperRifleSkinRed'
	   Skins(0)=Texture'UT3WeaponSkins.SniperRifle.T_WP_SniperRifle_D' //GE: The skin must not be a combiner or it gets the "ghost" effect
	   Mesh=SkeletalMesh'UT3WeaponAnims.SK_WP_SniperRifle_3P_Mid'
     RelativeLocation=(X=0,Y=-2,Z=1)
     RelativeRotation=(Pitch=32768,Yaw=16384)
     DrawScale=0.9
     mMuzFlash3rdClass=class'XEffects.AssaultMuzFlash3rd'
}

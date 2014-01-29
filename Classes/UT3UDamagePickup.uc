/******************************************************************************
UT3UDamagePickup

Creation date: 2008-07-19 18:14
Last change: $Id$
Copyright (c) 2008, 2010, 2013, 2014 Wormbo, 100GPing100, GreatEmerald
******************************************************************************/

class UT3UDamagePickup extends UT3TimedPickup;


//=============================================================================
// Imports
//=============================================================================

//#exec OBJ LOAD FILE=UT3PickupsOld.utx
#exec OBJ LOAD FILE=UT3Pickups-SM.usx

// GEm: UDamage doesn't use a pattern combiner and has two materials per mesh
simulated function PostBeginPlay()
{
    local Shader SpawnShader;

    Super.PostBeginPlay();

    // GEm: Skin that we'll apply to the pickup while spawning
    SpawnShader = new(None) class'Shader';
    SpawnShader.Diffuse = BasicTexture;
    SpawnShader.Opacity = TriggerTexture;
    SpawnShader.Specular = TriggerTexture;
    SpawnShader.SpecularityMask = TriggerTexture;

    // GEm: Get a FinalBlend to solve Z-sort issues
    SpawnSkin = new(None) class'FinalBlend';
    SpawnSkin.FrameBufferBlending = FB_AlphaBlend;
    SpawnSkin.Material = SpawnShader;
}

auto simulated state Pickup
{
Begin:
    CheckTouching();
    if (!bHidden)
        AmbientSound = SpawnedAmbientSound;

    if (SpawnSkin != None)
    {
        Skins[0] = SpawnSkin;
        Skins[1] = SpawnSkin;
        TriggerTexture.Trigger(Self, None);
        Sleep(GetSoundDuration(RespawnSound));
    }
    Skins = TempSkins;
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    InventoryType       = class'UT3UDamage'
    TimeRemaining       = 30.0
    RespawnSound        = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_Spawn'
    SpawnedAmbientSound = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_GroundLoop'
    PickupSound         = Sound'UT3A_Pickups_Powerups.Powerups.A_Powerup_UDamage_Pickup'
    PickupMessage       = "DAMAGE AMP!"
    MessageClass        = class'UT3PickupMessage'

    PickupForce  = "UDamagePickup"
    Physics      = PHYS_Rotating
    RotationRate = (Yaw=24000)

    DrawScale  = 0.6
    StaticMesh = StaticMesh'UT3Pickups-SM.Powerups.Udamage'

    SpawnBand = Material'UT3Pickups.Udamage.SpawnBandTexCoord'
    BasicTexture = Material'UT3Pickups.Udamage.UDamage_D'
}

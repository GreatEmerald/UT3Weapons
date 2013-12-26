//=============================================================================
// UT3AmmoPickup.uc
// The base of all UT3 ammo pickups, since it's more efficient this way
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3AmmoPickup extends UTAmmoPickup;

var UT3DecorativeMesh HighlightEffect;
var array<Material> HighlightSkins;

var() Sound RespawnSound;

var() Material PatternCombiner;
var() Material SpawnBand;
var() Material BasicTexture;
var TexPannerTriggered TriggerTexture;
var FinalBlend SpawnSkin;
var array<Material> TempSkins;

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();

    // GEm: Create spawn-in effect materials
    if (SpawnBand != None && RespawnSound != None)
        TriggerTexture = class'UT3MaterialManager'.static.GetTriggerTexture(SpawnBand, GetSoundDuration(RespawnSound));
    if (TriggerTexture != None && PatternCombiner != None && BasicTexture != None)
        SpawnSkin = class'UT3MaterialManager'.static.GetSpawnSkin(TriggerTexture, PatternCombiner, BasicTexture);

    // GEm: Back up our default Skins
    TempSkins = Skins;
}

simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();
    CheckHighlightEffect();
}

// GEm: Checks if the highlight exists, tries to spawn if not, returns false if it can't
simulated function bool CheckHighlightEffect()
{
    if (HighlightEffect != None)
        return true;

    HighlightEffect = Spawn(class'UT3DecorativeMesh'); // GEm: This is all client-side
    if (HighlightEffect == None)
        return false;
    HighlightEffect.SetStaticMesh(StaticMesh);
    HighlightEffect.Skins = HighlightSkins;
    HighlightEffect.SetDrawScale(DrawScale);
    HighlightEffect.PrePivot = PrePivot;
    return true;
}

simulated function BaseChange()
{
    if (CheckHighlightEffect())
    {
        HighlightEffect.SetLocation(Location);
    }
}

// GEm: Make sure we precache everything before level start
static function StaticPrecache(LevelInfo L)
{
    local int i;

    for (i = 0; i < default.HighlightSkins.length; i++)
        L.AddPrecacheMaterial(default.HighlightSkins[i]);
}

simulated function UpdatePrecacheMaterials()
{
    StaticPrecache(Level);
    Super.UpdatePrecacheMaterials();
}

// GEm: In netgames
simulated function PostNetReceive()
{
    // GEm: Respawn effect related:
    if (!bHidden)
        GotoState('Pickup');

    // GEm: Nice thing about bOnlyReplicateHidden – PostNetReceive is super predictable!
    if (HighlightEffect == None)
        return;

    if (bHidden)
        HighlightEffect.bHidden = true;
    /*else
    {
        HighlightEffect.bHidden = false;
        HighlightEffect.SetRotation(Rotation);
    }*/
}

// GEm: Locally
state Sleeping
{
    function BeginState()
    {
        Super.BeginState();
        if (HighlightEffect != None)
            HighlightEffect.bHidden = true;
    }

    /*simulated function EndState()
    {
        Super.EndState();
        if (HighlightEffect != None)
            HighlightEffect.bHidden = false;
    }*/
}

auto simulated state Pickup
{

    simulated function EndState()
    {
        // GEm: Reset skins to default, in case it's picked up before sleep is finished
        Skins = TempSkins;
        Super.EndState();
    }

// GEm: Use state time abilities to trigger and wait until the spawn effect is finished
Begin:
    if (SpawnSkin != None)
    {
        Skins[0] = SpawnSkin;
        TriggerTexture.Trigger(Self, None);
        Sleep(GetSoundDuration(RespawnSound));
    }
    Skins = TempSkins;
    if (HighlightEffect != None)
    {
        HighlightEffect.bHidden = false;
        HighlightEffect.SetRotation(Rotation);
    }
}

function RespawnEffect()
{
    PlaySound(RespawnSound, SLOT_Interact, TransientSoundVolume*1.4);
}

// GEm: In unexpected situations (CheckReplacement et al.)
function Destroyed()
{
    local int i;

    SpawnSkin = None;
    TriggerTexture = None;
    for (i = 0; i < TempSkins.Length; i++)
        TempSkins[i] = None;

    if (HighlightEffect != None)
        HighlightEffect.Destroy();

    Super.Destroyed();
}

defaultproperties
{
    RespawnSound = Sound'UT3A_Pickups.Ammo.A_Pickup_Ammo_Respawn01'
    bNetNotify = true
    RemoteRole = ROLE_SimulatedProxy
    AmbientGlow = 77
    DrawType = DT_StaticMesh
    MessageClass = class'UT3PickupMessage'
}

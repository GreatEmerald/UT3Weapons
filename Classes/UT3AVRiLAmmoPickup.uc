//=============================================================================
// UT3AVRiLAmmoPickup.uc
// Yet I still need the class for referencing AVRiLAmmo.
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//=============================================================================

class UT3AVRiLAmmoPickup extends ONSAVRiLAmmoPickup;

#exec obj load file=UT3Pickups.utx

var UT3AmmoHighlight HighlightEffect;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    HighlightEffect = Spawn(class'UT3AmmoHighlight'); // GEm: This is all client-side
    if (HighlightEffect == None)
        return;
    HighlightEffect.SetStaticMesh(default.StaticMesh);
    HighlightEffect.Skins[0] = Material'UT3Pickups.highlight.AVRIL_Highlight';
    HighlightEffect.SetDrawScale(default.DrawScale);
    HighlightEffect.PrePivot = default.PrePivot;
}

// GEm: In netgames
simulated function PostNetReceive()
{
    // GEm: Nice thing about bOnlyReplicateHidden – PostNetReceive is super predictable!
    if (HighlightEffect == None)
        return;

    if (bHidden)
        HighlightEffect.bHidden = true;
    else
        HighlightEffect.bHidden = false;
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

    function EndState()
    {
        Super.EndState();
        if (HighlightEffect != None)
            HighlightEffect.bHidden = false;
    }
}

// GEm: In unexpected situations (CheckReplacement et al.)
function Destroyed()
{
    if (HighlightEffect != None)
        HighlightEffect.Destroy();
    Super.Destroyed();
}

DefaultProperties
{
    InventoryType=class'UT3AVRiLAmmo' //what item to create in inventory (Epic comment)
    PickupMessage="Longbow AVRiL Ammo"
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.AVRILammo'
    DrawScale=1.8
    PrePivot=(Z=4.0)
    AmbientGlow=77
    bNetNotify=true
}

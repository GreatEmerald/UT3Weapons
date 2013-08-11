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
    HighlightEffect = Spawn(class'UT3AmmoHighlight'); // GEm: TODO: Spawn client-side only
    HighlightEffect.SetStaticMesh(default.StaticMesh);
    HighlightEffect.Skins[0] = Material'UT3Pickups.highlight.AVRIL_Highlight';
    HighlightEffect.SetDrawScale(default.DrawScale);
    HighlightEffect.PrePivot = default.PrePivot;
    Super.PostBeginPlay();
}

state Sleeping
{
    function BeginState()
    {
        Super.BeginState();
        HighlightEffect.bHidden = true;
    }

    function EndState()
    {
        Super.EndState();
        HighlightEffect.bHidden = false;
    }
}

simulated function Destroyed()
{
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
}

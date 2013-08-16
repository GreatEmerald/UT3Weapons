//=============================================================================
// UT3AmmoPickup.uc
// The base of all UT3 ammo pickups, since it's more efficient this way
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3AmmoPickup extends UTAmmoPickup;

var UT3AmmoHighlight HighlightEffect;
var array<Material> HighlightSkins;

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

    HighlightEffect = Spawn(class'UT3AmmoHighlight'); // GEm: This is all client-side
    if (HighlightEffect == None)
        return false;
    log(self@"CheckHighlightEffect: Rotation"@Rotation@"="@HighlightEffect.Rotation);
    HighlightEffect.SetStaticMesh(StaticMesh);
    HighlightEffect.Skins = HighlightSkins;
    HighlightEffect.SetDrawScale(DrawScale);
    HighlightEffect.PrePivot = PrePivot;
    return true;
}

simulated function BaseChange()
{
    if (CheckHighlightEffect())
        Highlighteffect.SetLocation(Location);
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
    {
        HighlightEffect.bHidden = false;
        HighlightEffect.SetRotation(Rotation);
    }
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

defaultproperties
{
    bNetNotify = true
    AmbientGlow = 77
    DrawType = DT_StaticMesh
}

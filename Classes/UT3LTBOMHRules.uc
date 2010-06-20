//=============================================================================
// UT3LTBOMHRules.uc
// "Like the Back of My Hand" Rules, similar to UT3, all handling is here
// 2010, GreatEmerald
//=============================================================================

class UT3LTBOMHRules extends GameRules;

var Array<UT3LTBOMHInteraction> InteractionArray;

//GE: Rerouting OverridePickupQuery to our Interactions.
function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup)  
{
    local int i;
    
    for (i = 0; i < InteractionArray.Length; ++i)
        InteractionArray[i].UpdatePickupStatus(Other, item);
    
  	return Super.OverridePickupQuery(Other, item, bAllowPickup);
}

//GE: Register and unregister interactions to and from the array.
function RegisterInteraction(UT3LTBOMHInteraction Interaction)
{
    InteractionArray[InteractionArray.Length] = Interaction;
}

function UnregisterInteraction(UT3LTBOMHInteraction Interaction)
{
    local int i;
 
    for (i = 0; i < InteractionArray.Length; ++i)
    {
        if (InteractionArray[i] == Interaction)
            InteractionArray.Remove(i--, 1);
    }
}

defaultproperties
{
}
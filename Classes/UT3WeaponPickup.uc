//=============================================================================
// UT3WeaponPickup.uc
// A cut-down version of UT3Pickup for weapons
// Copyright © 2014 GreatEmerald
//=============================================================================

class UT3WeaponPickup extends UTWeaponPickup
    notplaceable;

simulated event ClientTrigger()
{
    bHidden = true;
    if ( EffectIsRelevant(Location, false) && !Level.GetLocalPlayerController().BeyondViewDistance(Location, CullDistance)  )
        spawn(class'UT3WeaponFadeEffect',self);
}

auto simulated state Pickup
{
    function BeginState()
    {
        Super.BeginState();
        if (UT3PickupFactory(PickUpBase) != None)
        {
            UT3PickupFactory(PickUpBase).PulseState = PS_Static;
            UT3PickupFactory(PickUpBase).StartPulse();
        }
    }
}

state Sleeping
{
    function BeginState()
    {
        Super.BeginState();
        if (UT3PickupFactory(PickUpBase) != None)
        {
            UT3PickupFactory(PickUpBase).PulseState = PS_Off;
            UT3PickupFactory(PickUpBase).StartPulse();
        }
    }
}

defaultproperties
{
    MessageClass = class'UT3PickupMessage'
    AmbientGlow = 77
    DrawType = DT_StaticMesh
}

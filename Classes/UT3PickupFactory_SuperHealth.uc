//=============================================================================
// UT3PickupFactory_SuperHealth.uc
// A base for the Big Keg
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3PickupFactory_SuperHealth extends UT3HealthPickupFactory;

defaultproperties
{
    PowerUp = class'UT3HealthPickupSuper'
    bDelayedSpawn = true
}

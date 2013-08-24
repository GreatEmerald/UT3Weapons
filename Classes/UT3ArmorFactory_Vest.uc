//=============================================================================
// UT3ArmorFactory_Vest.uc
// Armoured vest base. Deviates from standard naming to prevent confusion.
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3ArmorFactory_Vest extends UT3ArmorPickupFactory;

defaultproperties
{
    PowerUp = class'UT3ArmorVestPickup'
}

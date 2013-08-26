//=============================================================================
// UT3PickupFactory_UDamage.uc
// The UDamage base with the spinny thingy
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3PickupFactory_UDamage extends UT3PowerupPickupFactory;

defaultproperties
{
    PowerUp = class'UT3UDamagePickup'
    BaseBrightSkins = Material'UT3Pickups.Base_Powerup.M_Pickups_Base_Powerup_UDamage'
    BaseDimSkins = Material'UT3Pickups.Base_Powerup.M_Pickups_Base_Powerup_UDamageDim'
}

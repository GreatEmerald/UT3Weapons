//==============================================================================
// UT3EnforcerAmmo.uc
// I can't locate sounds for pickup, strange...
// 2008, GreatEmerald
//==============================================================================

class UT3EnforcerAmmo extends AssaultAmmo;

defaultproperties
{
     MaxAmmo=100
     InitialAmount=50
     PickupClass=Class'UT3Style.UT3EnforcerAmmoPickup'
}

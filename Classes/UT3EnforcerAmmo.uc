//==============================================================================
// UT3EnforcerAmmo.uc
// I can't locate sounds for pickup, strange...
// 2008, GreatEmerald
//==============================================================================

class UT3EnforcerAmmo extends AssaultAmmo;

defaultproperties
{
    PickupClass=class'UT3EnforcerAmmoPickup'
    MaxAmmo=100
    InitialAmount=50
}


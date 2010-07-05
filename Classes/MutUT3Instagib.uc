//=============================================================================
// MutUT3Instagib.uc
// I need this as the usual InstaGib won't allow me to add the usual mutator together.
// 2008, GreatEmerald
//=============================================================================

class MutUT3Instagib extends MutInstaGib;

function bool MutatorIsAllowed()
{
    return true;
}

defaultproperties
{
     WeaponName="UT3InstagibRifle"
     AmmoName="SuperShockAmmo"
     WeaponString="UT3Style.UT3InstagibRifle"
     AmmoString="xWeapons.SuperShockAmmo"
     bAllowTranslocator=True
     DefaultWeaponName="UT3Style.UT3InstagibRifle"
     FriendlyName="UT3 InstaGib"
     Description="Instant-kill combat with modified UT3 Shock Rifles."
}

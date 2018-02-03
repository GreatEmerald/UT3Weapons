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
    AmmoName=SuperShockAmmo
    AmmoString="xWeapons.SuperShockAmmo"
    WeaponName=UT3InstagibRifle
    WeaponString="UT3Weapons.UT3InstagibRifle"
    DefaultWeaponName="UT3Weapons.UT3InstagibRifle"
    bAllowTranslocator=true

    IconMaterialName="MutatorArt.nosym"
    ConfigMenuClassName=""
    GroupName="Arena"
    FriendlyName="UT3 InstaGib"
    Description="Instant-kill combat with modified UT3 Shock Rifles."
}

//=============================================================================
// DamTypeUT3Instagib.uc
// Damage...
// 2008, GreatEmerald
//=============================================================================

class DamTypeUT3Instagib extends DamTypeSuperShockBeam;

defaultproperties
{
    WeaponClass=class'UT3InstagibRifle'
    GibPerterbation=0.500000
    DeathString="%o was gibbed by %k's super shock beam."
    MaleSuicide="%o somehow managed to shoot himself with the instagib rifle."
    FemaleSuicide="%o somehow managed to shoot herself with the instagib rifle."
}

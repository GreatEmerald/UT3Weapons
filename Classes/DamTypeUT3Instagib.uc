//=============================================================================
// DamTypeUT3Instagib.uc
// Damage...
// 2008, GreatEmerald
//=============================================================================

class DamTypeUT3Instagib extends DamTypeSuperShockBeam;

defaultproperties
{
     WeaponClass=Class'UT3Style.UT3InstagibRifle'
     DeathString="%o was gibbed by %k's super shock beam."
     FemaleSuicide="%o somehow managed to shoot herself with the instagib rifle."
     MaleSuicide="%o somehow managed to shoot himself with the instagib rifle."
     GibPerterbation=0.500000
}

//=============================================================================
// DamTypeUT3Sniper.uc
// Ooh, that had to hurt.
// 2008, GreatEmerald
//=============================================================================

class DamTypeUT3Sniper extends DamTypeClassicSniper;

defaultproperties
{
   DeathString="%o has been picked off by %k."
   FemaleSuicide="%o fell on his weapon and shot herself in the chest"
   MaleSuicide="%o fell on his weapon and shot himself in the chest."
   GibPerterbation=0.250000
   VehicleDamageScaling=0.400000
   WeaponClass=class'UT3SniperRifle'
}

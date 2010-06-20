//=============================================================================
// DamTypeUT3HeadShot.uc
// Ooh, that had to hurt.
// 2008, GreatEmerald
//=============================================================================

class DamTypeUT3HeadShot extends DamTypeClassicHeadShot;


defaultproperties
{
   DeathString="%o's grey matter has been ejected by %k."
   FemaleSuicide="%o fell on his weapon and shot herself in the head."
   MaleSuicide="%o fell on his weapon and shot himself in the head."

    WeaponClass=class'UT3SniperRifle'
    VehicleDamageScaling=0.400000
}

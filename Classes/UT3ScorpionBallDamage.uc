//-----------------------------------------------------------
// UT3ScorpionBallDamage.uc
// Scorpion Plasma Ball damage type
// 2009, GreatEmerald
//-----------------------------------------------------------
class UT3ScorpionBallDamage extends VehicleDamageType
  abstract;

defaultproperties
{
     VehicleClass=Class'UT3Style.UT3Scorpion'
     DeathString="%k's Scorpion blasted %o into oblivion."
     FemaleSuicide="%o blasted herself."
     MaleSuicide="%o blasted himself."
     bDetonatesGoop=True
     bDelayedDamage=True
     FlashFog=(X=700.000000)
     VehicleDamageScaling=0.750000
}

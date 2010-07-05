//-----------------------------------------------------------
// UT3ScorpionSDDamage.uc
// Scorpion Self Destruct damage type
// 2009, GreatEmerald
//-----------------------------------------------------------
class UT3ScorpionSDDamage extends VehicleDamageType
  abstract;

defaultproperties
{
     VehicleClass=Class'UT3Style.UT3Scorpion'
     DeathString="%o was too close to %k's Scorpion self destruct."
     FemaleSuicide="%o fried herself with her own Scorpion self destruct."
     MaleSuicide="%o fried himself with his own Scorpion self destruct."
     bDetonatesGoop=True
     bDelayedDamage=True
     FlashFog=(X=700.000000)
     KDamageImpulse=12000.000000
}

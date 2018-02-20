class DamTypeUT3RocketGrenade extends DamTypeUT3Rocket
	abstract;

defaultproperties
{
     WeaponClass=Class'UT3Weapons.UT3RocketLauncher'
     DeathString="%o caught %k's grenade."
     FemaleSuicide="%o landed on her own grenade."
     MaleSuicide="%o landed on his own grenade."
     bDetonatesGoop=True
     bDelayedDamage=True
}

//-----------------------------------------------------------
// UT3PaladinCannon.uc
// The main Paladin gun.
// Last change: Alpha 2
// By GreatEmerald, 2009
//-----------------------------------------------------------
class UT3PaladinCannon extends ONSShockTankCannon;

function ProximityExplosion() //Instant shock combo
{
    local Emitter ComboHit;

    ComboHit = Spawn(class'ONSShockTankShieldComboHit', self);
	if ( Level.NetMode == NM_DedicatedServer )
	{
		ComboHit.LifeSpan = 0.6;
	}
    AttachToBone(ComboHit, 'BigGun');
    ComboHit.SetRelativeLocation(vect(300,0,0));
    SetTimer(0.1, false);
}

defaultproperties
{
     MaxShieldHealth=1200.000000
     MaxDelayTime=2.500000
     ShieldRechargeRate=350.000000
     CurrentShieldHealth=1200.000000
     ProjectileClass=Class'UT3Style.UT3PaladinProjectile'
}

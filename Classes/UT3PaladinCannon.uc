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

DefaultProperties
{
   MaxShieldHealth=1200.000000    //GE: Exact Copy-Paste of the UT3 code
   MaxDelayTime=2.500000          //Increased
   ShieldRechargeRate=350.000000  //Decreased
   CurrentShieldHealth=1200.000000//Maximum Shield health is lower, but current is higher
   ProjectileClass=class'UT3PaladinProjectile'
}

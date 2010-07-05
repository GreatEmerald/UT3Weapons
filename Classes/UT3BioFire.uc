//==============================================================================
// UT3BioFire.uc
// To explode or not to explode?
// 2008, GreatEmerald
//==============================================================================

class UT3BioFire extends BioFire;

function PlayFiring()
{
	if ( Weapon.Mesh != None )
	{
		if ( FireCount > 0 )
		{
			if ( Weapon.HasAnim(FireAnim) )
			{
				If ( Weapon.PlayAnim(FireAnim) )
                {
                  Weapon.PlayAnim('WeaponFire2', 1.0, TweenTime);
                }
                Else If ( Weapon.PlayAnim('WeaponFire2') )
                {
                  Weapon.PlayAnim('WeaponFire3', 1.0, TweenTime);
                }
                Else If ( Weapon.PlayAnim('WeaponFire3') )
                {
                  Weapon.PlayAnim(FireAnim, 1.0, TweenTime);
                }
			}
			else
			{
				Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
			}
		}
		else
		{
			Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
		}
	}
    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

defaultproperties
{
     FireAnim="WeaponFire2"
     FireSound=Sound'UT3Weapons2.BioRifle.BioRifleFire'
     FireRate=0.350000
     AmmoClass=Class'UT3Style.UT3BioAmmo'
     ProjectileClass=Class'UT3Style.UT3BioGlob'
}

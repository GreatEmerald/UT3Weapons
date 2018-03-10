//==============================================================================
// UT3BioFire.uc
// To explode or not to explode?
// 2008, GreatEmerald
//==============================================================================

class UT3BioFire extends BioFire;

#exec obj load file=UT3A_Weapon_BioRifle.uax

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
    AmmoClass=class'UT3BioAmmo'

    ProjectileClass=class'UT3BioGlob'
    FireRate=0.35

    FireSound=Sound'UT3A_Weapon_BioRifle.UT3BioFireMain.UT3BioFireMainCue
    TransientSoundVolume=1.000000
    FireAnim="WeaponFire2"
    TweenTime=0.1
}

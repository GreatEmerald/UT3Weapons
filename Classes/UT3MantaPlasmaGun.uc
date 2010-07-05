//-----------------------------------------------------------------------------
// UT3MantaPlasmaGun.uc
// Sounds increased by 25%...
// GreatEmerald, 2008
//-----------------------------------------------------------------------------

class UT3MantaPlasmaGun extends ONSHoverBikePlasmaGun;

function float SuggestAttackStyle()
{
    local xBot B;

    B = xBot(Instigator.Controller);
    if ( (Pawn(Instigator.Controller.Focus) == None) || (B == None) || (B.Skill < 3) )
    {
        return -0.2;
    }

    return 0.2;
}

defaultproperties
{
     FireSoundClass=Sound'UT3Vehicles.Manta.MantaFire'
     ProjectileClass=Class'UT3Style.UT3MantaPlasmaProjectile'
     TransientSoundVolume=0.400000
}

/******************************************************************************
UT3RaptorWeapon

Creation date: 2008-05-02 20:34
Last change: Alpha 2
Copyright (c) 2008 and 2009, Wormbo and GreatEmerald
******************************************************************************/

class UT3RaptorWeapon extends ONSAttackCraftGun;

var(Sound) Sound HomingSound;

state ProjectileFireMode
{
    function Fire(Controller C)
    {
        if (Vehicle(Owner) != None && Vehicle(Owner).Team < 2)
            ProjectileClass = TeamProjectileClasses[Vehicle(Owner).Team];
        else
            ProjectileClass = TeamProjectileClasses[0];

        Super.Fire(C);
    }

    function AltFire(Controller C)
    {
        local ONSAttackCraftMissle M;
        local Vehicle V, Best;
        local float CurAim, BestAim;

        M = ONSAttackCraftMissle(SpawnProjectile(AltFireProjectileClass, True));
        if (M != None)
        {
            if (AIController(Instigator.Controller) != None)
            {
                V = Vehicle(Instigator.Controller.Enemy);
                if (V != None && (V.bCanFly || V.IsA('ONSHoverCraft')) && Instigator.FastTrace(V.Location, Instigator.Location))
                    M.SetHomingTarget(V);
            }
            else
            {
                BestAim = MinAim;
                for (V = Level.Game.VehicleList; V != None; V = V.NextVehicle)
                    if ((V.bCanFly || V.IsA('ONSHoverCraft')) && V != Instigator && Instigator.GetTeamNum() != V.GetTeamNum())
                    {
                        CurAim = Normal(V.Location - WeaponFireLocation) dot vector(WeaponFireRotation);
                        if (CurAim > BestAim && Instigator.FastTrace(V.Location, Instigator.Location))
                        {
                            Best = V;
                            BestAim = CurAim;
                        }
                    }
                if (Best != None) {
                    M.SetHomingTarget(Best);
                    PlayOwnedSound(HomingSound, SLOT_Interact, 2.5*TransientSoundVolume);
                }
            }
        }
    }
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     HomingSound=Sound'UT3Weapons2.Generic.LockOn'
     TeamProjectileClasses(0)=Class'UT3Style.UT3RaptorProjRed'
     TeamProjectileClasses(1)=Class'UT3Style.UT3RaptorProjBlue'
     MinAim=0.930000
     RotationsPerSecond=0.110000
     AltFireInterval=1.200000
     FireSoundClass=Sound'UT3Vehicles.RAPTOR.RaptorFire'
     AltFireSoundClass=Sound'UT3Vehicles.RAPTOR.RaptorAltFire'
     ProjectileClass=Class'UT3Style.UT3RaptorProjRed'
     AltFireProjectileClass=Class'UT3Style.UT3RaptorRocket'
}

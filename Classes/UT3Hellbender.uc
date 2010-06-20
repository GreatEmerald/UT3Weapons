/******************************************************************************
UT3Hellbender

Creation date: 2008-05-02 20:51
Last change: $Id$
Copyright (c) 2008 and 2009, Wormbo and GreatEmerald
******************************************************************************/

class UT3Hellbender extends ONSPRV;
//This is a great example of how to get rid of a passenger seat.

function VehicleFire(bool bWasAltFire) //This is to remove the horn each time you fire
{
    Super(ONSWheeledCraft).VehicleFire(bWasAltFire);
}

function AltFire(optional float F) //This is to remove the horn each time you fire
{
    Super(ONSWheeledCraft).AltFire(F);
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType)
{                            //Make sure you don't hurt yourself with a combo
    if (InstigatedBy != self)
    Super.TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
}

event bool IsVehicleEmpty() //Starting the removal of one seat - everywhere length-1
{
    local int i;

    if ( Driver != None )
        return false;

    for (i=0; i<(WeaponPawns.length)-1; i++)
        if ( WeaponPawns[i].Driver != None )
            return false;

    return true;
}

static function StaticPrecache(LevelInfo L)
{
    local int i;

    for(i=0;i<Default.DriverWeapons.Length;i++)
        Default.DriverWeapons[i].WeaponClass.static.StaticPrecache(L);

    for(i=0;i<(Default.PassengerWeapons.Length)-1;i++)
        Default.PassengerWeapons[i].WeaponPawnClass.static.StaticPrecache(L);

    if (Default.DestroyedVehicleMesh != None)
        L.AddPrecacheStaticMesh(Default.DestroyedVehicleMesh);

    if (Default.HeadlightCoronaMaterial != None)
        L.AddPrecacheMaterial(Default.HeadLightCoronaMaterial);

    if (Default.HeadlightProjectorMaterial != None)
        L.AddPrecacheMaterial(Default.HeadLightProjectorMaterial);

    L.AddPrecacheMaterial( default.VehicleIcon.Material );

    L.AddPrecacheMaterial(Material'EmitterTextures.MultiFrame.LargeFlames');
    L.AddPrecacheMaterial(Material'EmitterTextures.MultiFrame.fire3');
    L.AddPrecacheMaterial(Texture'AW-2004Particles.Weapons.DustSmoke');
    L.AddPrecacheStaticMesh(StaticMesh'ONSDeadVehicles-SM.HELLbenderExploded.HellTire');
    L.AddPrecacheStaticMesh(StaticMesh'ONSDeadVehicles-SM.HELLbenderExploded.HellDoor');
    L.AddPrecacheStaticMesh(StaticMesh'ONSDeadVehicles-SM.HELLbenderExploded.HellGun');
    L.AddPrecacheStaticMesh(StaticMesh'AW-2004Particles.Debris.Veh_Debris2');
    L.AddPrecacheStaticMesh(StaticMesh'AW-2004Particles.Debris.Veh_Debris1');

    L.AddPrecacheMaterial(Material'AW-2004Particles.Energy.SparkHead');
    L.AddPrecacheMaterial(Material'ExplosionTex.Framed.exp2_frames');
    L.AddPrecacheMaterial(Material'ExplosionTex.Framed.exp1_frames');
    L.AddPrecacheMaterial(Material'ExplosionTex.Framed.we1_frames');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Fire.MuchSmoke1');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Fire.NapalmSpot');
    L.AddPrecacheMaterial(Material'EpicParticles.Fire.SprayFire1');
    L.AddPrecacheMaterial(Material'VMVehicles-TX.NEWprvGroup.newPRVnoColor');
    L.AddPrecacheMaterial(Material'VMVehicles-TX.NEWprvGroup.PRVcolorRED');
    L.AddPrecacheMaterial(Material'VMVehicles-TX.NEWprvGroup.PRVcolorBLUE');
    L.AddPrecacheMaterial(Material'VMVehicles-TX.NEWprvGroup.EnergyEffectMASKtex');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Energy.PowerSwirl');
    L.AddPrecacheMaterial(Material'VMWeaponsTX.ManualBaseGun.baseGunEffectcopy');
    L.AddPrecacheMaterial(Material'VehicleFX.Particles.DustyCloud2');
    L.AddPrecacheMaterial(Material'VMParticleTextures.DirtKICKGROUP.dirtKICKTEX');
    L.AddPrecacheMaterial(Material'Engine.GRADIENT_Fade');
    L.AddPrecacheMaterial(Material'VMVehicles-TX.NEWprvGroup.PRVtagFallBack');
    L.AddPrecacheMaterial(Material'VMVehicles-TX.NEWprvGroup.prvTAGSCRIPTED');
}

simulated function PostNetBeginPlay()
{
    local int i;

    // Count the number of powered wheels on the car
    NumPoweredWheels = 0.0;
    for(i=0; i<Wheels.Length; i++)
    {
        NumPoweredWheels += 1.0;
    }

    Super(SVehicle).PostNetBeginPlay();

    if (Role == ROLE_Authority)
    {
        // Spawn the Driver Weapons
        for(i=0;i<DriverWeapons.Length;i++)
        {
            // Spawn Weapon
            Weapons[i] = spawn(DriverWeapons[i].WeaponClass, self,, Location, rot(0,0,0));
            AttachToBone(Weapons[i], DriverWeapons[i].WeaponBone);
            if (!Weapons[i].bAimable)
                Weapons[i].CurrentAim = rot(0,32768,0);
        }

        if (ActiveWeapon < Weapons.length)
        {
            PitchUpLimit = Weapons[ActiveWeapon].PitchUpLimit;
            PitchDownLimit = Weapons[ActiveWeapon].PitchDownLimit;
        }

        // Spawn the Passenger Weapons
        for(i=0;i<(PassengerWeapons.Length)-1;i++)
        {
            // Spawn WeaponPawn
            WeaponPawns[i] = spawn(PassengerWeapons[i].WeaponPawnClass, self,, Location);
            WeaponPawns[i].AttachToVehicle(self, PassengerWeapons[i].WeaponBone);
            if (!WeaponPawns[i].bHasOwnHealth)
                WeaponPawns[i].HealthMax = HealthMax;
            WeaponPawns[i].ObjectiveGetOutDist = ObjectiveGetOutDist;
        }
    }

    if(Level.NetMode != NM_DedicatedServer && Level.DetailMode > DM_Low && SparkEffectClass != None)
    {
        SparkEffect = spawn( SparkEffectClass, self,, Location);
    }

    if(Level.NetMode != NM_DedicatedServer && Level.bUseHeadlights && !(Level.bDropDetail || (Level.DetailMode == DM_Low)))
    {
        HeadlightCorona.Length = HeadlightCoronaOffset.Length;

        for(i=0; i<HeadlightCoronaOffset.Length; i++)
        {
            HeadlightCorona[i] = spawn( class'ONSHeadlightCorona', self,, Location + (HeadlightCoronaOffset[i] >> Rotation) );
            HeadlightCorona[i].SetBase(self);
            HeadlightCorona[i].SetRelativeRotation(rot(0,0,0));
            HeadlightCorona[i].Skins[0] = HeadlightCoronaMaterial;
            HeadlightCorona[i].ChangeTeamTint(Team);
            HeadlightCorona[i].MaxCoronaSize = HeadlightCoronaMaxSize * Level.HeadlightScaling;
        }

        if(HeadlightProjectorMaterial != None && Level.DetailMode == DM_SuperHigh)
        {
            HeadlightProjector = spawn( class'ONSHeadlightProjector', self,, Location + (HeadlightProjectorOffset >> Rotation) );
            HeadlightProjector.SetBase(self);
            HeadlightProjector.SetRelativeRotation( HeadlightProjectorRotation );
            HeadlightProjector.ProjTexture = HeadlightProjectorMaterial;
            HeadlightProjector.SetDrawScale(HeadlightProjectorScale);
            HeadlightProjector.CullDistance = ShadowCullDistance;
        }
    }

    SetTeamNum(Team);
    TeamChanged();
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	VehicleNameString = "UT3 Hellbender"
	VehiclePositionString="in a Hellbender"
	DriverDamageMult=0.0
	MomentumMult=1.000000
	DriverWeapons(0)=(WeaponClass=class'UT3HellbenderSideGun',WeaponBone=Dummy01);
    PassengerWeapons(0)=(WeaponPawnClass=class'UT3HellbenderRearGunPawn',WeaponBone=Dummy02);
    PassengerWeapons(1)=(WeaponPawnClass=none,WeaponBone=Dummy02);
    IdleSound=sound'UT3Vehicles.HELLBENDER.HellbenderAmbient'
    StartUpSound=sound'UT3Vehicles.HELLBENDER.HellbenderEnter'
    ShutDownSound=sound'UT3Vehicles.HELLBENDER.HellbenderEmpty'
    //TransientSoundVolume=1.0
    SoundVolume=255
    GroundSpeed=700
    HornSounds(0)=sound'UT3Vehicles.HELLBENDER.HellbenderHorn'
    SteerSpeed=220
    EntryRadius=300.0
    TPCamWorldOffset=(X=0,Y=0,Z=200)
    //TPCamDistance=375
    MaxSteerAngleCurve=(Points=((InVal=0,OutVal=50.0),(InVal=1500.0,OutVal=8.0),(InVal=1000000000.0,OutVal=8.0)))
}

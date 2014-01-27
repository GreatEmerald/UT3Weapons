/******************************************************************************
UT3ArmorPickup

Creation date: 2008-07-20 12:30
Last change: $Id$
Copyright (c) 2008, 2013, 2014 Wormbo, GreatEmerald
******************************************************************************/

class UT3ArmorPickup extends UT3Pickup abstract;


//=============================================================================
// Imports
//=============================================================================


function int CanUseArmor(Pawn Other)
{
	local UT3Armor Armor;

	Armor = UT3Armor(Other.FindInventoryType(InventoryType));
	if (Armor != None) {
		return InventoryType.Default.Charge - Armor.Charge;
	}
	return InventoryType.Default.Charge;
}

function float BotDesireability(Pawn Bot)
{
	local float Desire;

	Desire = 0.013 * MaxDesireability * CanUseArmor(Bot);

	if (!Level.Game.bTeamGame && AIController(Bot.Controller) != None && AIController(Bot.Controller).Skill >= 4.0) {
		// consider denying the enemy a chance to pick up this armor
		Desire = FMax(Desire, 0.001);
	}
	return Desire;
}


function float DetourWeight(Pawn Other, float PathWeight)
{
	local float Need;

	Need = CanUseArmor(Other);
	if (AIController(Other.Controller).PriorityObjective() && Need < 0.4 * InventoryType.Default.Charge)
		return (0.005 * MaxDesireability * Need) / PathWeight;
	if (Need <= 0) {
		if (!Level.Game.bTeamGame)
			Need = 0.5;
		else
			return 0;
	}
	else if (!Level.Game.bTeamGame)
		Need = FMax(Need, 0.6);
	return (0.013 * MaxDesireability * Need) / PathWeight;
}

auto simulated state Pickup
{
    function BeginState()
    {
        Super.BeginState();
        if (UT3PickupFactory(PickUpBase) != None)
        {
            UT3PickupFactory(PickUpBase).PulseState = PS_Static;
            UT3PickupFactory(PickUpBase).StartPulse();
        }
    }
}

state Sleeping
{
    function BeginState()
    {
        Super.BeginState();
        if (UT3PickupFactory(PickUpBase) != None)
        {
            UT3PickupFactory(PickUpBase).PulseState = PS_Off;
            UT3PickupFactory(PickUpBase).StartPulse();
        }
    }

DelayedSpawn:
Begin:
    if (UT3PickupFactory(PickUpBase) != None)
    {
        Sleep(GetReSpawnTime() - UT3PickupFactory(PickUpBase).PulseThreshold);
        UT3PickupFactory(PickUpBase).PulseState = PS_Pulsing;
        UT3PickupFactory(PickUpBase).StartPulse();
        Sleep(UT3PickupFactory(PickUpBase).PulseThreshold);
    }
    else
        Sleep(GetReSpawnTime() - RespawnEffectTime);
Respawn:
    RespawnEffect();
    Sleep(RespawnEffectTime);
    if (PickUpBase != None)
        PickUpBase.TurnOn();
    GotoState('Pickup');
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    bPredictRespawns = true
    RespawnTime = 30.0
    RespawnSound = Sound'UT3A_Pickups.Armor.A_Pickups_Armor_Respawn01'
    MaxDesireability = 1.0
    AmbientGlow = 77
    PatternCombiner = Material'UT3Pickups.Vest.SpawnPatternMultiply'
    SpawnBand = Material'UT3Pickups.Vest.SpawnBandTexCoord'
    Physics = PHYS_Rotating
    RotationRate = (Yaw=24000)
}

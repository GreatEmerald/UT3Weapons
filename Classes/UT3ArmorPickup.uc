/******************************************************************************
UT3ArmorPickup

Creation date: 2008-07-20 12:30
Last change: $Id$
Copyright (c) 2008, Wormbo
******************************************************************************/

class UT3ArmorPickup extends UT3Pickup abstract;


//=============================================================================
// Imports
//=============================================================================

#exec audio import group=Pickups file=Sounds\include\RespawnArmor.wav


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


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
	bPredictRespawns = true
	RespawnTime = 30.0
	RespawnSound = Sound'RespawnArmor'
	MaxDesireability = 1.0
}

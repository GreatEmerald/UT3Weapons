//=============================================================================
// MutBackOfMyHand.uc
// A version of "Like the back of my hand" award in UT3
// 2010, GreatEmerald
//=============================================================================

class MutBackOfMyHand extends Mutator;

/*
 * GE: How it works: The mutator spawns GameRules, which in turn handles all of
 * the pickups. Then we use an Interaction to draw all kinds of things on the
 * player's HUD.
 * This is right now an SP-only thing, not sure if there is a purpose for this
 * being in MP. Possibly is, though... Exploration server? Would be interesting.
 * It might also just work online for all I know.
 * Every player has one Interaction and there is only one instance of GameRules.
 * GameRules has access to OverridePickupQuery(), but we want to make it per
 * client, so it's rerouted to the Interaction.      
 */

var UT3LTBOMHRules Rules;
var bool bHasInteraction, bRebuilt;
var localized string GUIDisplayText[2]; //GE: WTF, what's wrong with having an array size of 1 for future considerations?..
var localized string GUIDescText[2];
var config bool bReinitialise;

/* GE: The list of all pickups is saved here. Must be the same for all people -
 * have to disregard all the additional pickups spawned by things like 
 * UDamageAward. Also doing once for speed.
 * The pool is huge and unordered. Doing all the ordering in the Interaction
 * class.  
 */ 
var Array<Actor> PickupList; 

//GE: Spawn GameRules. 
event PostBeginPlay()
{
    local Mutator M;
    local byte B;
    
    Super.PostBeginPlay();
    
    for ( M=self; M!=None; M=M.NextMutator ) //GE: This For loop forces the mutator to be the last in the mutator chain.
    {
        B++;
        if (B > 100) //GE: infinite loop control.
            break;
        
        if ( M.NextMutator != None && M.NextMutator.Class == Class ) //GE: If there is another copy of us down the line, kill ourselves
        {
            Destroy();
            break;
        }
        else if (M.NextMutator == None && M != self) //GE: If we reached the end of the line and we're not in it, spawn a new mutator
            AddMutator(self);
    } 
    
    FindAllPickups(); //GE: Actually find the pickups before doing everything else :P
    
    Rules = Spawn(class'UT3LTBOMHRules');
    if (Rules != None)
    {
        if ( Level.Game.GameRulesModifiers == None )
                Level.Game.GameRulesModifiers = Rules;
        else
            Level.Game.AddGameModifier(Rules);
    }
}

//GE: Spawn an Interaction for every player and register it.
simulated function Tick(float DeltaTime)
{
  	local PlayerController PC;
  	local int i;
   
  	Super.Tick(DeltaTime);
    // If the player has an interaction already, exit function.
  	if (bHasInteraction)
    		Return;
  	PC = Level.GetLocalPlayerController();
   
  	// Run a check to see whether this mutator should create an interaction for the player
  	if ( PC != None && !PC.PlayerReplicationInfo.bIsSpectator )
  	{
    		PC.Player.InteractionMaster.AddInteraction("UT3Style.UT3LTBOMHInteraction", PC.Player); // Create the interaction
    		for (i = 0; i < PC.Player.LocalInteractions.Length; ++i)
        {
            if (UT3LTBOMHInteraction(PC.Player.LocalInteractions[i]) != None)
            {
                Rules.RegisterInteraction(UT3LTBOMHInteraction(PC.Player.LocalInteractions[i]));
                //log("MutBackOfMyHand: The PickupList exists:"@PickupList.Length);
                RegisterPickups(UT3LTBOMHInteraction(PC.Player.LocalInteractions[i]));
                break; //GE: We spawned only one interaction per player, and you wouldn't like to keep people waiting, would you?
            }
        }
    		bHasInteraction = True; // Set the variable so this lot isn't called again
    		if (!bRebuilt && bReinitialise)
            SetTimer(0.5, False);
  	}
}

event Timer()
{
    RebuildLTBOMH();
    Super.Timer();
}

//GE: Find all pickups and add them to the huge array there.
//CheckReplacement isn't used because it's not called once, and we don't need duplicates.
function FindAllPickups()
{
    local Actor Other;
    
    ForEach AllActors(class'Actor', Other)
    {
        if ( xPickUpBase(Other) != None || //GE: Add all PickupBases.
            (UTAmmoPickup(Other) != None && UTAmmoPickup(Other).PickUpBase == None) || //GE: Add all Ammo without bases etc.
            (AdrenalinePickup(Other) != None && AdrenalinePickup(Other).PickUpBase == None) || //GE: Not just adding TournamentPickup for things like RPG pickups.
            (ShieldPickup(Other) != None && ShieldPickup(Other).PickUpBase == None) ||
            (TournamentHealth(Other) != None && TournamentHealth(Other).PickUpBase == None) ||
            (UDamagePack(Other) != None && UDamagePack(Other).PickUpBase == None) ||
            WeaponLocker(Other) != None || //GE: Lockers are standalone, and we need them for ONS
            (UTWeaponPickup(Other) != None && UTWeaponPickup(Other).PickUpBase == None) //GE: Notplaceable, shouldn't happen, but just in case someone subclasses it
            ) 
            PickupList[PickupList.Length] = Other;
    }
}

//GE: Send the information we have to each Interaction.
function RegisterPickups(UT3LTBOMHInteraction Interaction)
{
    local int i;
    
    Interaction.ClearLists();
    for (i=0; i<PickupList.Length; ++i)
    {
        //log("MutBackOfMyHand: Number"@i@"in the Pickup List is"@PickupList[i]);
        Interaction.RegisterPickup(PickupList[i]);
    }
}

//GE: In order to maintain a clean player list, unregister the interaction of
//this person here.
function NotifyLogout(Controller Exiting)
{
    UnregisterInt(Exiting);
    Super.NotifyLogout(Exiting);
}

function UnregisterInt(Controller C)
{
    local int i;
    local Player ExitingPlayer;
    
    //GE: Don't want to risk a return nor putting Super above the code
    if (PlayerController(C) != None && PlayerController(C).Player != None)
    {
        ExitingPlayer = PlayerController(C).Player;
        for (i = 0; i < ExitingPlayer.LocalInteractions.Length; ++i)
        {
            if (UT3LTBOMHInteraction(ExitingPlayer.LocalInteractions[i]) != None)
            {
                Rules.UnregisterInteraction(UT3LTBOMHInteraction(ExitingPlayer.LocalInteractions[i]));
                UT3LTBOMHInteraction(ExitingPlayer.LocalInteractions[i]).NotifyLevelChange();
                break; //GE: We spawned only one interaction per player, and you wouldn't like to keep people waiting, would you?
            }
        }
    }
}

function Mutate(string MutateString, PlayerController Sender)
{
    if (MutateString ~= "RebuildLTBOMH")
    {
        FindAllPickups(); //GE: Rebuild the list
        UnregisterInt(Level.GetLocalPlayerController()); //GE: Deinit the interaction
        bHasInteraction = False; //GE: Rebuild it
    }
    Super.Mutate(MutateString, Sender);
}

function RebuildLTBOMH()
{
    FindAllPickups(); //GE: Rebuild the list
    UnregisterInt(Level.GetLocalPlayerController()); //GE: Deinit the interaction
    bHasInteraction = False; //GE: Rebuild it
    bRebuilt = True; //GE: Don't call this again.
}

static function string GetDisplayText(string PropName) 
{
    switch (PropName)
    {
        case "bReinitialise":  return default.GUIDisplayText[0];
    }
    return "";
}

static event string GetDescriptionText(string PropName) {
    switch (PropName)
    {
        case "bReinitialise":  return default.GUIDescText[0];
    }
    return Super.GetDescriptionText(PropName);
}

static function FillPlayInfo(PlayInfo PlayInfo) 
{
    Super.FillPlayInfo(PlayInfo);
   
    PlayInfo.AddSetting(default.GameGroup, "bReinitialise", GetDisplayText("bReinitialise"), 0, 0, "Check");
}

defaultproperties
{
    IconMaterialName="MutatorArt.nosym"
    FriendlyName="UT3 Like the Back of My Hand"
    Description="Addds a counter of all the pickups in the map and how many of those you have picked up already, and does an announcement when you manage pick up all of them. This way it emulates UT3 award 'Like the Back of My Hand' and promotes map exploration."
    bAddToServerPackages=True
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
    bReinitialise=true
    GUIDisplayText(0)="Enable reinitialisation"
    GUIDescText(0)="Uncheck this if you are planning to use this mutator without any weapon/item replacement mutators. When checked, it might report non-existant pickups, when unchecked, it won't report some pickups at all."
}
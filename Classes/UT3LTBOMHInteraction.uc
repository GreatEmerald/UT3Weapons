//=============================================================================
// UT3LTBOMHInteraction.uc
// "Like the Back of My Hand" Interaction, similar to UT3, all handling is here
// 2010, GreatEmerald
//=============================================================================

class UT3LTBOMHInteraction extends Interaction;

#exec OBJ LOAD FILE=announcermale2k4.uax

/*
 * GE: What happens here is that on spawn, each Interaction gets a unified list
 * of all the pickups in the level (possibly from the Mutator), registers it
 * here and changes PickupArray.PickupNode.bComplete to true for every pickup
 * that the player touches (different from UT3 - far less annoying).
 * Now why the PickupReference is an Actor? That's because pickups such as ammo
 * are different from pickups from xPickupBases. Each Pickup has its own unique
 * name, but pickups spawned by xPickupBases don't. So instead of registering
 * such pickups, we need to register their xPickupBases.
 * 
 * We have different lists for all of the different pickups. The HUD might be
 * set to merge some of the information. Possibly controlled by config.
 * Hybrid arrays contain both pickups and their bases (since some people love
 * to add non-based versions of pickups into their maps).
 * Unknown array keeps all of the leftover pickups that don't fall into any of
 * the given arrays. Probably custom pickups.        
 */
struct PickupNode 
{
    var Actor PickupReference;
    var bool bComplete;
};
var Array<PickupNode> HealthArray; //GE: Hybrid array
var Array<PickupNode> ShieldArray; //GE: Hybrid array
var Array<PickupNode> SuperHealthArray; //GE: Hybrid array
var Array<PickupNode> SuperShieldArray; //GE: Hybrid array
var Array<PickupNode> UDamageArray; //GE: Hybrid array
var Array<PickupNode> WildcardArray;
var Array<PickupNode> WeaponArray; //GE: Possibly hybrid array
var Array<PickupNode> SuperWeaponArray; //GE: Possibly hybrid array
var Array<PickupNode> AmmoArray;
var Array<PickupNode> AdrenalineArray;
var Array<PickupNode> VialArray;
var Array<PickupNode> LockerArray;
var Array<PickupNode> UnknownArray;
var int HealthFound, ShieldFound, SuperHealthFound, SuperShieldFound; //GE: Because a struct of array of struct is ludicrous
var int UDamageFound, WildcardFound, WeaponFound, SuperWeaponFound, AmmoFound;
var int AdrenalineFound, VialFound, LockerFound, UnknownFound;
var() float HUDSpaceSize;
var sound AnnouncementSound;
var bool bBeaten;

/******************************************************************************
 * Creates the pickup list
 ******************************************************************************/ 

//GE: Clear the pickup list (reinitialisation purposes)
function ClearLists()
{
    HealthArray.Length = 0;
    ShieldArray.Length = 0;
    SuperHealthArray.Length = 0;
    SuperShieldArray.Length = 0;
    UDamageArray.Length = 0;
    WildcardArray.Length = 0;
    WeaponArray.Length = 0;
    SuperWeaponArray.Length = 0;
    AmmoArray.Length = 0;
    AdrenalineArray.Length = 0;
    VialArray.Length = 0;
    LockerArray.Length = 0;
    UnknownArray.Length = 0;
}

//GE: Destination is for special handling of which array to put the pickup in. -not used
//By now we are spawned, don't know anything and getting raw info on all pickups.
//Gets called a gazillion times.
function RegisterPickup(Actor MyPickup)//, optional string Destination)
{    
    local PickupNode PN;
    local Sound S;
    local int i;
    
    //GE: Register the award announcement
    if (AnnouncementSound == None)
    {
        S = ViewportOwner.Actor.RewardAnnouncer.GetSound('Totalled');
        if (S == None)
            AnnouncementSound = Sound'announcermale2k4.Totalled';
    }    
    
    if ( HealthCharger(MyPickup) != None || HealthPack(MyPickup) != None )
    {
        UpdateList(MyPickup, HealthArray);
        return; //GE: We found what we wanted, no need to worry about other ifs.
    }
    if (ShieldCharger(MyPickup) != None || ShieldPack(MyPickup) != None) //GE: No else since we already returned from everything above.
    {
        UpdateList(MyPickup, ShieldArray);
        return;
    }
    if ( SuperHealthCharger(MyPickup) != None || SuperHealthPack(MyPickup) != None )
    {
        UpdateList(MyPickup, SuperHealthArray);
        return;
    }
    if ( SuperShieldCharger(MyPickup) != None || SuperShieldPack(MyPickup) != None )
    {
        UpdateList(MyPickup, SuperShieldArray);
        return;
    }
    if ( UDamageCharger(MyPickup) != None || UDamagePack(MyPickup) != None )
    {
        UpdateList(MyPickup, UDamageArray);
        return;
    }
    if ( WildcardBase(MyPickup) != None )
    {
        UpdateList(MyPickup, WildcardArray);
        return;
    }
    if ( xWeaponBase(MyPickup) != None)
    {
        PN.PickupReference = MyPickup;
        if (xWeaponBase(MyPickup).WeaponType.default.PickupClass.default.MaxDesireability >= 1.0)
        {
            for (i=0; i < SuperWeaponArray.Length; i++) //GE: Check for duplicates
            {
                if (SuperWeaponArray[i].PickupReference == MyPickup)
                    return;
            }
            SuperWeaponArray[SuperWeaponArray.Length] = PN;
        }
        else
        {
            for (i=0; i < WeaponArray.Length; i++) //GE: Check for duplicates
            {
                if (WeaponArray[i].PickupReference == MyPickup)
                    return;
            }
            WeaponArray[WeaponArray.Length] = PN;
        }
        return;
    }
    if ( WeaponPickup(MyPickup) != None )
    {
        PN.PickupReference = MyPickup;
        if (WeaponPickup(MyPickup).MaxDesireability >= 1.0) //GE: If players really want it, it's probably a superweapon.
        {
            for (i=0; i < SuperWeaponArray.Length; i++) //GE: Check for duplicates
            {
                if (SuperWeaponArray[i].PickupReference == MyPickup)
                    return;
            }
            SuperWeaponArray[SuperWeaponArray.Length] = PN;
        }
        else
        {
            for (i=0; i < WeaponArray.Length; i++) //GE: Check for duplicates
            {
                if (WeaponArray[i].PickupReference == MyPickup)
                    return;
            }
            WeaponArray[WeaponArray.Length] = PN;
        }
        return;
    }
    if ( Ammo(MyPickup) != None )
    {
        UpdateList(MyPickup, AmmoArray);
        return;
    }
    if ( AdrenalinePickup(MyPickup) != None )
    {
        UpdateList(MyPickup, AdrenalineArray);
        return;
    }
    if ( MiniHealthPack(MyPickup) != None )
    {
        UpdateList(MyPickup, VialArray);
        return;
    }
    if ( WeaponLocker(MyPickup) != None )
    {
        UpdateList(MyPickup, LockerArray);
        return;
    }
    //GE: If nothing above was executed, this will be.
    UpdateList(MyPickup, UnknownArray);
}

//GE: Labour saving yay! Her we add things to the lists.
function UpdateList(Actor MyPickup, out array<PickupNode> Destination)
{
    local PickupNode PN;
    local int i;
    
    for (i=0; i < Destination.Length; i++) //GE: Check for duplicates
    {
        if (Destination[i].PickupReference == MyPickup)
            return;
    }
    PN.PickupReference = MyPickup;
    Destination[Destination.Length] = PN;

}

/******************************************************************************
 * Finds which pickups you just picked up
 ******************************************************************************/

function UpdatePickupStatus(Pawn Receiver, Pickup Item)
{
    local Actor Query;
    
    //GE: Discard any pickups that were done by other players.
    if (ViewportOwner.Actor.Pawn != Receiver)
        return;
    
    Query = GetQuery(Item);
    //ViewportOwner.Actor.ClientMessage("UT3LTBOMHInteraction: Picked up"@Item@"and checking"@Query);
    
    if ( WildcardBase(Query) != None ) //GE: Since wildcard can be anything, they have priority over others
    {
        SaveProgress(Query, WildcardArray, WildcardFound);
        return;
    }
    if ( HealthPack(Query) != None || HealthCharger(Query) != None )
    {
        SaveProgress(Query, HealthArray, HealthFound);
        return;
    }
    if ( ShieldPack(Query) != None || ShieldCharger(Query) != None )
    {
        SaveProgress(Query, ShieldArray, ShieldFound);
        return;
    }
    if ( SuperHealthPack(Query) != None || SuperHealthCharger(Query) != None )
    {
        SaveProgress(Query, SuperHealthArray, SuperHealthFound);
        return;
    }
    if ( SuperShieldPack(Query) != None || SuperShieldCharger(Query) != None )
    {
        SaveProgress(Query, SuperShieldArray, SuperShieldFound);
        return;
    }
    if ( UDamagePack(Query) != None || UDamageCharger(Query) != None)
    {
        SaveProgress(Query, UDamageArray, UDamageFound);
        return;
    }
    if ( WeaponPickup(Item) != None || xWeaponBase(Query) != None)
    {
        if (WeaponPickup(Item).MaxDesireability >= 1.0)
            SaveProgress(Query, SuperWeaponArray, SuperWeaponFound);
        else
            SaveProgress(Query, WeaponArray, WeaponFound);
        return;
    }
    if ( Ammo(Item) != None )
    {
        SaveProgress(Query, AmmoArray, AmmoFound);
        return;
    }
    if ( AdrenalinePickup(Item) != None )
    {
        SaveProgress(Query, AdrenalineArray, AdrenalineFound);
        return;
    }
    if ( MiniHealthPack(Item) != None )
    {
        SaveProgress(Query, VialArray, VialFound);
        return;
    }
    if ( WeaponLocker(Item) != None )
    {
        SaveProgress(Query, LockerArray, LockerFound);
        return;
    }
    //GE: At this point, all the pickups have been filtered. What's left are
    //custom classes. We don't know whether we have the bases or the actual
    //pickups registered in the UnknownArray, so let's make sure.
    if ( xPickUpBase(Query) != None )
    {
        SaveProgress(Query, UnknownArray, UnknownFound);
        SaveProgress(Item, UnknownArray, UnknownFound);
    }
    else
        SaveProgress(Item, UnknownArray, UnknownFound);
}

//GE: Saves copy-paste work, returns either the base or the pickup itself
function Actor GetQuery(Pickup Item)
{
    if (Item.PickUpBase != None)
        return Item.PickUpBase;
    else
        return Item;
}

//GE: More copy-paste labour-saving, highly experimental since I'm not sure
//how arrays as parameters work.
//Puts bComplete tags into the arrays.
//If this doesn't find anything, just drops it. That means that additional pickups
//were spawned in the game - we disregard them.
function SaveProgress(Actor Query, out array<PickupNode> Destination, out int PickupFound)
{
    local int i;
    //local int FoundPickup;
    
    for (i=0; i<Destination.Length; i++)
    {
        if (Destination[i].PickupReference == Query && !Destination[i].bComplete)
        {
            Destination[i].bComplete = True;
            
            ++PickupFound;
            //CheckForVictory();
            //return;
            
            //FoundPickup = GetFoundFromDestination(Destination);
            //if (FoundPickup != None)
            //    PickupFound( FoundPickup );
        }
    }
    //UpdateHUD();
}

//GE: Input an array to receive an int in exchange!
function int GetFoundFromDestination(array<PickupNode> Destination)
{
    if (Destination == HealthArray) { return HealthFound; }
    if (Destination == ShieldArray) { return ShieldFound; }
    if (Destination == SuperHealthArray) { return SuperHealthFound; }
    if (Destination == SuperShieldArray) { return SuperShieldFound; }
    if (Destination == UDamageArray) { return UDamageFound; }
    if (Destination == WildcardArray) { return WildcardFound; }
    if (Destination == WeaponArray) { return WeaponFound; }
    if (Destination == SuperWeaponArray) { return SuperWeaponFound; }
    if (Destination == AmmoArray) { return AmmoFound; }
    if (Destination == AdrenalineArray) { return AdrenalineFound; }
    if (Destination == VialArray) { return VialFound; }
    if (Destination == LockerArray) { return LockerFound; }
    if (Destination == UnknownArray) { return UnknownFound; }
    
    if (Destination[0].PickupReference != None)
        warn("UT3Style.UT3LTBOMHInteraction: GetFoundFromDestination failed! Input was"@Destination[0].PickupReference);
    else
        warn("UT3Style.UT3LTBOMHInteraction: GetFoundFromDestination failed! Input was corrupted or empty!");
    return UnknownFound;
}
/******************************************************************************
 * Draws current info on screen
 ******************************************************************************/
 
//GE: The list of pickups might be huge, so recalculating each pickup type every
//tick is a stupid idea. So we'll have global variables for getting all the info
//and one function to update it when necessary.
//tl;dr: calculating all numbers - slow, reading a variable - fast

//GE: I could theoretically just note what I added and where, but I don't want
//to risk going off the scale with something like 100/12.
function UpdateHUD()
{    
    //GE: We don't count the totals because Array.Length is already there.
    
    if (bBeaten)
        return; //GE: Since we already won, don't bother updating it
    
    //GE: Reset the current counter and then recount. Should be fast enough
    //not to be noticeable by the end user.
    /*Recalculate(HealthFound, HealthArray);
    Recalculate(ShieldFound, ShieldArray);
    Recalculate(SuperHealthFound, SuperHealthArray);
    Recalculate(SuperShieldFound, SuperShieldArray);
    Recalculate(UDamageFound, UDamageArray);
    Recalculate(WildcardFound, WildcardArray);
    Recalculate(WeaponFound, WeaponArray);
    Recalculate(SuperWeaponFound, SuperWeaponArray);
    Recalculate(AmmoFound, AmmoArray);
    Recalculate(AdrenalineFound, AdrenalineArray);
    Recalculate(VialFound, VialArray);
    Recalculate(LockerFound, LockerArray);
    Recalculate(UnknownFound, UnknownArray);*/ 
    CheckForVictory();
}

//GE: labour-saving part of UpdateHUD(), we calculate the current number of
//pickups found here
function Recalculate(out int Statistic, array<PickupNode> Target)
{
    local int i;
    
    Statistic = 0; //GE: Would reset to defaults, but there's no way to get them
    
    for (i=0; i<Target.Length; ++i)
    {
        if (Target[i].bComplete)
            ++Statistic;
    }
}

//GE: Checking if we got everything
function CheckForVictory()
{     
     local array<string> CompletedMaps;
     local string MapName, URL;
     local int i;
     
     if (HealthFound == HealthArray.Length && ShieldFound == ShieldArray.Length &&
        SuperHealthFound == SuperHealthArray.Length && SuperShieldFound == SuperShieldArray.Length &&
        UDamageFound == UDamageArray.Length && WildcardFound == WildcardArray.Length &&
        WeaponFound == WeaponArray.Length && SuperWeaponFound == SuperWeaponArray.Length &&
        AmmoFound == AmmoArray.Length && AdrenalineFound == AdrenalineArray.Length &&
        VialFound == VialArray.Length)
      {
          if (AnnouncementSound == None)
              ViewportOwner.Actor.PlayRewardAnnouncement('Totalled', 1, true);
          else
              ViewportOwner.Actor.ClientPlaySound(AnnouncementSound,true,2.0 * FClamp(0.1 + float(ViewportOwner.Actor.AnnouncerVolume)*0.225,0.2,1.0),SLOT_Talk);
          
          ViewportOwner.Actor.ClientMessage("All powerups found!", 'CriticalEvent');
          bBeaten = True;
          CompletedMaps = class'UT3LTBOMHMapList'.static.StaticGetMaps();
          URL = ViewportOwner.Actor.GetURLMap(true);
          MapName = class'MaplistRecord'.static.GetBaseMapName(URL);
          for (i=0; i<CompletedMaps.Length; ++i)
          {
              if (CompletedMaps[i] ~= MapName)
                  return;
          }
          CompletedMaps[CompletedMaps.Length] = MapName;
          class'UT3LTBOMHMapList'.static.SetMaplist(CompletedMaps.Length, CompletedMaps);
      }
}

//GE: Finally, draw all this on HUD. Phew.
function PostRender( canvas Canvas )
{    
    Canvas.Style = ViewportOwner.Actor.ERenderStyle.STY_Normal;
    Canvas.DrawColor = class'HUD'.Default.WhiteColor;
    Canvas.Font = Canvas.MedFont;
    Canvas.DrawScreenText("Health:"@HealthFound$"/"$HealthArray.Length, 1.0, 0.85, DP_LowerRight);
    Canvas.DrawScreenText("Shields:"@ShieldFound$"/"$ShieldArray.Length, 1.0, 0.85-(HUDSpaceSize*1), DP_LowerRight);
    Canvas.DrawScreenText("Big Keg O' Health:"@SuperHealthFound$"/"$SuperHealthArray.Length, 1.0, 0.85-(HUDSpaceSize*2), DP_LowerRight);
    Canvas.DrawScreenText("Super Shields:"@SuperShieldFound$"/"$SuperShieldArray.Length, 1.0, 0.85-(HUDSpaceSize*3), DP_LowerRight);
    Canvas.DrawScreenText("UDamage:"@UDamageFound$"/"$UDamageArray.Length, 1.0, 0.85-(HUDSpaceSize*4), DP_LowerRight);
    Canvas.DrawScreenText("Wildcards:"@WildcardFound$"/"$WildcardArray.Length, 1.0, 0.85-(HUDSpaceSize*5), DP_LowerRight);
    Canvas.DrawScreenText("Weapons:"@WeaponFound$"/"$WeaponArray.Length, 1.0, 0.85-(HUDSpaceSize*6), DP_LowerRight);
    Canvas.DrawScreenText("Super weapons:"@SuperWeaponFound$"/"$SuperWeaponArray.Length, 1.0, 0.85-(HUDSpaceSize*7), DP_LowerRight);
    Canvas.DrawScreenText("Ammo:"@AmmoFound$"/"$AmmoArray.Length, 1.0, 0.85-(HUDSpaceSize*8), DP_LowerRight);
    Canvas.DrawScreenText("Adrenaline:"@AdrenalineFound$"/"$AdrenalineArray.Length, 1.0, 0.85-(HUDSpaceSize*9), DP_LowerRight);
    Canvas.DrawScreenText("Health vials:"@VialFound$"/"$VialArray.Length, 1.0, 0.85-(HUDSpaceSize*10), DP_LowerRight);
    Canvas.DrawScreenText("Weapon lockers:"@LockerFound$"/"$LockerArray.Length, 1.0, 0.85-(HUDSpaceSize*11), DP_LowerRight);
    Canvas.DrawScreenText("Unknown pickups:"@UnknownFound$"/"$UnknownArray.Length, 1.0, 0.85-(HUDSpaceSize*12), DP_LowerRight);
    UpdateHUD();
}

/******************************************************************************
 * Destroys itself
 ******************************************************************************/

event NotifyLevelChange()
{
    Master.RemoveInteraction( Self );
}

/******************************************************************************
 * Utils - for debugging
 ******************************************************************************/

exec function PrintList(string Variable, optional int i)
{
    local array<PickupNode> CurrentArray;
    
    if (Variable ~= "HealthArray") { CurrentArray = HealthArray; }
    if (Variable ~= "ShieldArray") { CurrentArray = ShieldArray; }
    if (Variable ~= "SuperHealthArray") { CurrentArray = SuperHealthArray; }
    if (Variable ~= "SuperShieldArray") { CurrentArray = SuperShieldArray; }
    if (Variable ~= "UDamageArray") { CurrentArray = UDamageArray; }
    if (Variable ~= "WildcardArray") { CurrentArray = WildcardArray; }
    if (Variable ~= "WeaponArray") { CurrentArray = WeaponArray; }
    if (Variable ~= "SuperWeaponArray") { CurrentArray = SuperWeaponArray; }
    if (Variable ~= "AmmoArray") { CurrentArray = AmmoArray; }
    if (Variable ~= "AdrenalineArray") { CurrentArray = AdrenalineArray; }
    if (Variable ~= "VialArray") { CurrentArray = VialArray; }
    if (Variable ~= "LockerArray") { CurrentArray = LockerArray; }
    if (Variable ~= "UnknownArray") { CurrentArray = UnknownArray; }
    
    if (i > 0)
        ViewportOwner.Actor.ClientMessage(Variable$"["$i$"] ="@CurrentArray[i].PickupReference);
    else
    {
        for (i=0; i < CurrentArray.Length; i++)
            ViewportOwner.Actor.ClientMessage(Variable$"["$i$"] ="@CurrentArray[i].PickupReference);
    }
    
}

exec function PrintPickup(string Variable, optional int i)
{
    local array<PickupNode> CurrentArray;
    
    if (Variable ~= "HealthArray") { CurrentArray = HealthArray; }
    if (Variable ~= "ShieldArray") { CurrentArray = ShieldArray; }
    if (Variable ~= "SuperHealthArray") { CurrentArray = SuperHealthArray; }
    if (Variable ~= "SuperShieldArray") { CurrentArray = SuperShieldArray; }
    if (Variable ~= "UDamageArray") { CurrentArray = UDamageArray; }
    if (Variable ~= "WildcardArray") { CurrentArray = WildcardArray; }
    if (Variable ~= "WeaponArray") { CurrentArray = WeaponArray; }
    if (Variable ~= "SuperWeaponArray") { CurrentArray = SuperWeaponArray; }
    if (Variable ~= "AmmoArray") { CurrentArray = AmmoArray; }
    if (Variable ~= "AdrenalineArray") { CurrentArray = AdrenalineArray; }
    if (Variable ~= "VialArray") { CurrentArray = VialArray; }
    if (Variable ~= "LockerArray") { CurrentArray = LockerArray; }
    if (Variable ~= "UnknownArray") { CurrentArray = UnknownArray; }
    
    if (i > 0)
        ViewportOwner.Actor.ClientMessage(xPickUpBase(CurrentArray[i].PickupReference).PowerUp);
    else
    {
        for (i=0; i < CurrentArray.Length; i++)
            ViewportOwner.Actor.ClientMessage(xPickUpBase(CurrentArray[i].PickupReference).PowerUp);
    }
    
}

defaultproperties
{
    bVisible=true
    bActive=true
    HUDSpaceSize=0.02
}
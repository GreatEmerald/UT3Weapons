//------------------------------------------------------------------------------
// Takes care of catching the actual kill notifications for us.
//------------------------------------------------------------------------------
//=============================================================================
// UT3WeapMilestoneAnnounceRules.uc
// Removed some more original things from it to make it true to the original
// Copyright © 2014 GreatEmerald
//=============================================================================
class UT3WeapMilestoneAnnounceRules extends GameRules;

#exec OBJ LOAD FILE="..\Sounds\MutWeapMilestoneAnnounce_Snd.uax"

struct _PlayerDamageData
{
    var Controller C;
    var class<DamageType> LastDamageType;
    var int ShieldGunCount, AssaultRifleCount, BioRifleCount, MinigunCount,
     LinkGunCount, RocketLauncherCount, AVRiLCount;
};
var array<_PlayerDamageData> DamageData;

var int AwardCount;

function PostBeginPlay()
{
    if ( Level.Game.GameRulesModifiers == None )
        Level.Game.GameRulesModifiers = self;
    else
        Level.Game.GameRulesModifiers.AddGameRules(self);

    // Make sure clients have the sounds available!
    AddToPackageMap("MutWeapMilestoneAnnounce_Snd.uax");
}


function ScoreKill(Controller Killer, Controller Killed)
{
    local int i;

    if (Killer != Killed && UnrealPlayer(Killer) != None && Killed != None)
    {
        for (i = 0; i < DamageData.Length; i++)
        {
            if (DamageData[i].C == Killed)
            {
                CheckDamageType(Killer, DamageData[i].LastDamageType);
                break;
            }
            else if (DamageData[i].C == None)
            {
                DamageData.Remove(i, 1);
                i--;
            }
        }

    }

    if ( NextGameRules != None )
        NextGameRules.ScoreKill(Killer,Killed);
}

// Increase an individual player's kill counter with a specific weapon if he killed someone with it.
function CheckDamageType(Controller Killer, class<DamageType> DmgType)
{
    local int i;
    local _PlayerDamageData NewStruct;

    for (i = 0; i < DamageData.Length; i++)
    {
        if (DamageData[i].C == Killer)
        {
            PlaySpreeMessages(Killer, DmgType, DamageData[i]);
            return;
        }
        else if (DamageData[i].C == None)
        {
            DamageData.Remove(i, 1);
            i--;
        }
    }

    // Don't have it yet? Add a struct and try again!
    NewStruct.C = Killer;
    DamageData[DamageData.Length] = NewStruct;

    for (i = 0; i < DamageData.Length; i++)
    {
        if (DamageData[i].C == Killer)
        {
            PlaySpreeMessages(Killer, DmgType, DamageData[i]);
            return;
        }
    }
}

function PlaySpreeMessages(Controller Killer, class<DamageType> DmgType, out _PlayerDamageData PDI)
{
    if (ClassIsChildOf(DmgType, class'DamTypeAssaultBullet'))
    {
        PDI.AssaultRifleCount++;
        if (PDI.AssaultRifleCount == AwardCount)
            UnrealPlayer(Killer).ReceiveLocalizedMessage(class'UT3WeapMilestoneMessage', 1, Killer.PlayerReplicationInfo);
    }
    else if (ClassIsChildOf(DmgType, class'DamTypeBioGlob') || ClassIsChildOf(DmgType, class'UT3DamTypeBioGlob'))
    {
        PDI.BioRifleCount++;
        if (PDI.BioRifleCount == AwardCount)
            UnrealPlayer(Killer).ReceiveLocalizedMessage(class'UT3WeapMilestoneMessage', 2, Killer.PlayerReplicationInfo);
    }
    else if (ClassIsChildOf(DmgType, class'DamTypeLinkShaft'))
    {
        PDI.LinkGunCount++;
        if (PDI.LinkGunCount == AwardCount)
            UnrealPlayer(Killer).ReceiveLocalizedMessage(class'UT3WeapMilestoneMessage', 4, Killer.PlayerReplicationInfo);
    }
    else if (ClassIsChildOf(DmgType, class'DamTypeShieldImpact'))
    {
        PDI.ShieldGunCount++;
        if (PDI.ShieldGunCount == AwardCount)
            UnrealPlayer(Killer).ReceiveLocalizedMessage(class'UT3WeapMilestoneMessage', 0, Killer.PlayerReplicationInfo);
    }
    else if (ClassIsChildOf(DmgType, class'DamTypeRocket') || ClassIsChildOf(DmgType, class'DamTypeAssaultGrenade'))
    {
        PDI.RocketLauncherCount++;
        if (PDI.RocketLauncherCount == AwardCount)
            UnrealPlayer(Killer).ReceiveLocalizedMessage(class'UT3WeapMilestoneMessage', 5, Killer.PlayerReplicationInfo);
    }
    else if (ClassIsChildOf(DmgType, class'DamTypeONSAVRiLRocket'))
    {
        PDI.AVRiLCount++;
        if (PDI.AVRiLCount == AwardCount)
            UnrealPlayer(Killer).ReceiveLocalizedMessage(class'UT3WeapMilestoneMessage', 6, Killer.PlayerReplicationInfo);
    }
    else if (ClassIsChildOf(DmgType, class'DamTypeMinigunBullet') || ClassIsChildOf(DmgType, class'UT3DamTypeStingerShard'))
    {
        PDI.MinigunCount++;
        if (PDI.MinigunCount == AwardCount)
            UnrealPlayer(Killer).ReceiveLocalizedMessage(class'UT3WeapMilestoneMessage', 3, Killer.PlayerReplicationInfo);
    }
}

// Catch what damagetype is going to cause a player's death.
function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    if (NextGameRules != None && NextGameRules.PreventDeath(Killed,Killer, damageType,HitLocation))
        return True;
    else
    {
        if (Killed != None && Killed.Controller != None)
            AddDamageType(Killed.Controller, DamageType);

        return False;
    }
}

// Remembers the last damagetype that a player got hurt by before he's likely to die.
function AddDamageType(Controller Playa, class<DamageType> DamType)
{
    local int i;
    local _PlayerDamageData NewStruct;

    for (i = 0; i < DamageData.Length; i++)
    {
        if (DamageData[i].C == Playa)
        {
            DamageData[i].LastDamageType = DamType;
            return;
        }
        else if (DamageData[i].C == None)
        {
            DamageData.Remove(i, 1);
            i--;
        }
    }
    NewStruct.C = Playa;
    NewStruct.LastDamageType = DamType;
    DamageData[DamageData.Length] = NewStruct;
}

defaultproperties
{
    AwardCount = 15
}

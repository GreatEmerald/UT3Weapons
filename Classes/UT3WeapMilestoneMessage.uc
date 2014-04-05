//=============================================================================
// UT3WeapMilestoneMessage.uc
// A message for weapon specialisation kills, because UT3 has those
// Copyright © 2013 GreatEmerald
//=============================================================================
class UT3WeapMilestoneMessage extends CriticalEventPlus;

var localized string SelfSpreeNote[10];
var sound SpreeSound[10];

static function int GetFontSize( int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer )
{
    local Pawn ViewPawn;
    if ( RelatedPRI2 == None )
    {
        if ( LocalPlayer == RelatedPRI1 )
            return 2;
        if ( LocalPlayer.bOnlySpectator )
        {
            ViewPawn = Pawn(LocalPlayer.Level.GetLocalPlayerController().ViewTarget);
            if ( (ViewPawn != None) && (ViewPawn.PlayerReplicationInfo == RelatedPRI1) )
                return 2;
        }
    }
    return Default.FontSize;
}

static function string GetRelatedString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    if ( RelatedPRI_2 == None )
        return Default.SelfSpreeNote[Switch];

    return static.GetString(Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

static simulated function ClientReceive(
    PlayerController P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    if (RelatedPRI_2 != None)
        return;

    if ( (RelatedPRI_1 == P.PlayerReplicationInfo)
        || (P.PlayerReplicationInfo.bOnlySpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)) )
        P.PlayAnnouncement(Default.SpreeSound[Switch],1,true);
    else
        P.PlayBeepSound();
}

defaultproperties
{
    SelfSpreeNote(0) = "JackHammer!"
    SelfSpreeNote(1) = "Gun Slinger!"
    SelfSpreeNote(2) = "Bio Hazard!"
    SelfSpreeNote(3) = "Blue Streak!"
    SelfSpreeNote(4) = "Shaft Master!"
    SelfSpreeNote(5) = "Rocket Scientist!"
    SelfSpreeNote(6) = "Big Game Hunter!"
    SelfSpreeNote(7) = "Flak Master!"
    SelfSpreeNote(8) = "Head Hunter!"
    SelfSpreeNote(9) = "Combo King!"
    SpreeSound(0) = sound'MutWeapMilestoneAnnounce_Snd.Announcements.A_RewardAnnouncer_JackHammer'
    SpreeSound(1) = sound'MutWeapMilestoneAnnounce_Snd.Announcements.A_RewardAnnouncer_Gunslinger'
    SpreeSound(2) = sound'MutWeapMilestoneAnnounce_Snd.Announcements.A_RewardAnnouncer_Biohazard'
    SpreeSound(3) = sound'MutWeapMilestoneAnnounce_Snd.Announcements.A_RewardAnnouncer_BlueStreak'
    SpreeSound(4) = sound'MutWeapMilestoneAnnounce_Snd.Announcements.A_RewardAnnouncer_ShaftMaster'
    SpreeSound(5) = sound'MutWeapMilestoneAnnounce_Snd.Announcements.A_RewardAnnouncer_RocketScientist'
    SpreeSound(6) = sound'MutWeapMilestoneAnnounce_Snd.Announcements.A_RewardAnnouncer_BigGameHunter'
    FontSize = 0
    PosY = 0.865
}

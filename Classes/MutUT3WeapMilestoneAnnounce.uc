//------------------------------------------------------------------------------
// A Mutator that plays the 15-kills announcements (Flak Monkey, etc.) for more
// weapons than just Flak, Shock and Sniper.
//
// $wotgreal_dt: 04.11.2012 04:27:29$
// by Crusha K. Rool, sound courtesy of UT3 by Epic Games
// MappingCrocodile@googlemail.com
//------------------------------------------------------------------------------
//=============================================================================
// MutUT3WeapMilestoneAnnounce.uc
// This mutator aids the UT3 announcer pack when using UT3 weapons
// Copyright © 2014 GreatEmerald
//=============================================================================
class MutUT3WeapMilestoneAnnounce extends Mutator;

function PostBeginPlay()
{
    local UT3WeapMilestoneAnnounceRules G;

    Super.PostBeginPlay();
    G = spawn(class'UT3WeapMilestoneAnnounceRules');
    // That's it. These GameRules take care of adding themselves in PostBeginPlay().
}

DefaultProperties
{
     GroupName="Announcement"
     FriendlyName="UT3 Weapon Streak Announcement"
     Description="Announces streaks for every weapon, not just for Flak Monkeys and Combo Whores. This version works with the UT3 weapon variants."
}

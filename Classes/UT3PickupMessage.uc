//=============================================================================
// UT3PickupMessage.uc
// Message that shows a multiplier when several pickups are taken
// Copyright © 2013 GreatEmerald
//=============================================================================

class UT3PickupMessage extends PickupMessagePlus;

var protected float LastDisplayTime;
var protected string LastDisplayString;
var protected int LastDisplayCount;
var protected float CurrentTime;

/* GEm: This function is for some weird reason called three times on each
        pickup, and only the last return value actually matters. Crazy! */
static function string GetString
    (
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local string LocalString;
    local string CounterString;
    local int Count;

    if (class<Actor>(OptionalObject) != None)
    {
        LocalString = class<Actor>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
        CounterString = LocalString;
        Count = (default.LastDisplayCount)/3+1;

        log("UT3PickupMessage: GetString: LastDisplayCount"@default.LastDisplayCount@"means Count"@Count);
        if (LocalString == default.LastDisplayString && default.CurrentTime != 0.0
            && default.CurrentTime - default.LastDisplayTime <= default.Lifetime)
        {
            default.LastDisplayCount++;
            if (Count > 1)
                CounterString = LocalString@"x"$Count;
            log("UT3PickupMessage: GetString: Printing modded message"@CounterString);
        }
        else
            ResetLastDisplay();
        default.LastDisplayString = LocalString;
        default.LastDisplayTime = default.CurrentTime;

        return CounterString;
    }
    return Super.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

static function ResetLastDisplay()
{
    default.LastDisplayTime = 0.0;
    default.LastDisplayString = "";
    default.LastDisplayCount = 1;
    log("UT3PickupMessage: ResetLastDisplay");
}

static function ClientReceive(
    PlayerController P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    default.CurrentTime = P.Level.TimeSeconds;
    if (default.LastDisplayTime > default.CurrentTime)
        ResetLastDisplay();

    Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
    LastDisplayCount = 1
    PosY = 0.86
}

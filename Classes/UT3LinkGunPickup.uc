/******************************************************************************
UT3LinkGunPickup

Creation date: 2008-07-17 11:16
Last change: $Id$
Copyright (c) 2008, 2013, 2014 Wormbo, GreatEmerald
******************************************************************************/

class UT3LinkGunPickup extends UT3WeaponPickup;

function float BotDesireability(Pawn Bot)
{
    local Bot B;
    local DestroyableObjective O;

    B = Bot(Bot.Controller);
    if (B != None && B.Squad != None)
    {
        O = DestroyableObjective(B.Squad.SquadObjective);
        if ( O != None && O.TeamLink(B.GetTeamNum()) && O.Health < O.DamageCapacity && VSize(Bot.Location - O.Location) < 2000
            && (AllowRepeatPickup() || Bot.FindInventoryType(InventoryType) == None) )
            return MaxDesireability * 2;
    }

    return Super.BotDesireability(Bot);
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
    InventoryType = class'UT3LinkGun'
    PickupSound=Sound'UT3PickupSounds.LinkGunPickup'
    Skins(0)=Shader'UT3WeaponSkins.LinkGun.LinkGunSkin'
    PickupMessage="Link Gun"
    PickupForce="LinkGunPickup"
    StaticMesh=StaticMesh'UT3WPStatics.UT3LinkGunPickup'
    PrePivot=(Y=24)
    DrawScale=1.1
    Standup=(X=0.25,Y=0.0,Z=0.25) // GEm: This is actually a rotator in tau radians
    MaxDesireability=+0.7
}

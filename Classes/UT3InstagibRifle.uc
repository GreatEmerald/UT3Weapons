//=============================================================================
// UT3InstagibRifle.uc
// Mmm, giblets.
// 2008, GreatEmerald
//=============================================================================

class UT3InstagibRifle extends UT3ShockRifle
    HideDropDown
    CacheExempt;

simulated event RenderOverlays( Canvas Canvas )
{
    if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1) )
        ConstantColor'UT2004Weapons.ShockControl'.Color = class'HUD'.Default.BlueColor;
    else
        ConstantColor'UT2004Weapons.ShockControl'.Color = class'HUD'.Default.RedColor;
    Super.RenderOverlays(Canvas);
}

simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
    return true;
}

simulated function CheckOutOfAmmo()
{
}

function float GetAIRating()
{
    return AIRating;
}

simulated function bool StartFire(int mode)
{
    bWaitForCombo = false;
    return Super.StartFire(mode);
}

function float RangedAttackTime()
{
    return 0;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
    return 0;
}

defaultproperties
{
     RedSkin=Shader'UT3WeaponSkins.ShockRifle.InstagibRifleSkin'
     BlueSkin=Shader'UT3WeaponSkins.ShockRifle.InstagibRifleSkinB'
     FireModeClass(0)=Class'UT3Style.UT3SuperShockBeamFire'
     FireModeClass(1)=Class'UT3Style.UT3SuperShockBeamFire'
     AIRating=1.000000
     bCanThrow=False
     CustomCrossHairTextureName="UT3HUD.Crosshairs.UT3CrosshairInstagib"
     PickupClass=Class'UT3Style.UT3InstagibRiflePickup'
     IconCoords=(X1=361,Y1=239,X2=444,Y2=259)
     ItemName="UT3 Instagib Rifle"
     Skins(0)=Shader'UT3WeaponSkins.ShockRifle.InstagibRifleSkin'
     bNetNotify=False
}

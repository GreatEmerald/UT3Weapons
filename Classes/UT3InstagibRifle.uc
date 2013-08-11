//=============================================================================
// UT3InstagibRifle.uc
// Mmm, giblets.
// 2008, GreatEmerald
//=============================================================================

class UT3InstagibRifle extends UT3ShockRifle
    HideDropDown
    CacheExempt;

var const Material RedSkin, BlueSkin;

simulated function ApplySkin()
{
    local Controller Contra;
    local UT3ShockRifleAttachment Tach;

    if (Instigator.Controller != None)
        Contra = Instigator.Controller;
    else
        return;

    Tach = UT3ShockRifleAttachment(ThirdPersonActor);
    if ( (Contra != None) && (Contra.PlayerReplicationInfo != None)&& (Contra.PlayerReplicationInfo.Team != None) )
    {
        if ( Contra.PlayerReplicationInfo.Team.TeamIndex == 0 )
        {
            Skins[0] = RedSkin;
            if (Tach != None)
                Tach.Skins[0] = RedSkin;
        }
        else if ( Contra.PlayerReplicationInfo.Team.TeamIndex == 1 )
        {
            Skins[0] = BlueSkin;
            if (Tach != None)
                Tach.Skins[0] = BlueSkin;
        }
        //log("UT3ShockRifle: Tach skin is"@Tach.Skins[0]);
    }
}

function AttachToPawn(Pawn P)
{
    Super.AttachToPawn(P);
    ApplySkin(); //GE: Applying skin here instead of PostBeginPlay() since we don't have the Instigator nor attachment there yet... We get Instigator on GiveTo, Attachment here.
}

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
    bCanThrow=false
    AIRating=+1.0
    bNetNotify=false

    FireModeClass(0)=UT3SuperShockBeamFire
    FireModeClass(1)=UT3SuperShockBeamFire
    //AttachmentClass=class'UT3InstagibRifleAttachment'
    InventoryGroup=4
    ItemName="UT3 Instagib Rifle"
    PickupClass=class'UT3InstagibRiflePickup'
    HudColor=(B=255,G=0,R=160,A=255)
    CustomCrosshairTextureName="UT3HUD.Crosshairs.UT3CrosshairInstagib"
	CustomCrosshairColor=(B=255,G=0,R=160,A=255)
	CustomCrosshairScale=1.0

	IconMaterial=Material'UT3HUD.Icons.UT3IconsScaled'
    IconCoords=(X1=361,Y1=239,X2=444,Y2=259)
    
     Skins(0)=Shader'UT3WeaponSkins.ShockRifle.InstagibRifleSkin'
     RedSkin=Shader'UT3WeaponSkins.ShockRifle.InstagibRifleSkin'
     BlueSkin=Shader'UT3WeaponSkins.ShockRifle.InstagibRifleSkinB'
}


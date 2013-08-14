//==============================================================================
// UT3EnforcerAmmoPickup.uc
// Anyone..?
// 2008, 2010, 2013 GreatEmerald, 100GPing100
//==============================================================================

class UT3EnforcerAmmoPickup extends UT3AmmoPickup;

defaultproperties
{
    InventoryType=class'UT3EnforcerAmmo'

    PickupMessage="Enforcer Clip"
    PickupSound=Sound'UT3PickupSounds.Generic.EnforcerClipPickup'
    TransientSoundVolume=1.15
    PickupForce="AssaultAmmoPickup"

    AmmoAmount=16
    StaticMesh=StaticMesh'UT3Pickups-SM.Ammo.EnforcerAmmo'
    DrawScale=1.25
    PrePivot=(Z=11.0)
    CollisionHeight=12.5
    HighlightSkins(0)=Material'UT3Pickups.Ammo_Enforcer.Enforcer_Highlight'
}

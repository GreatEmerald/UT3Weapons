//=============================================================================
// UT3AVRiLBeam.uc
// ARRGH! Why did they put the beam start calculations HERE?!?!
// 2010, GreatEmerald
//=============================================================================

class UT3AVRiLBeam extends ONSMineLayerTargetBeamEffect;

var bool bBoneAttach;

simulated function Tick(float deltaTime)
{
    local vector StartTrace, X, Y, Z;
    local float Dist;

    if (bCancel)
    {
        Cancel();
        disable('Tick');
        return;
    }

    if (Instigator == None)
        return;

    if (Instigator.IsFirstPerson())
    {
        Instigator.Weapon.GetViewAxes(X, Y, Z);
        StartTrace = GetBeamStart(X,Y,Z);
        
    }
    else if (xPawn(Instigator) != None && xPawn(Instigator).WeaponAttachment != None)
        StartTrace = xPawn(Instigator).WeaponAttachment.GetTipLocation();
    else
        StartTrace = Instigator.Location + Instigator.EyeHeight * Vect(0,0,1) + Normal(vector(Rotation)) * 25.0;
    
    if (!bBoneAttach)
    {
        SetLocation(StartTrace);
        SetRotation(rotator(EndEffect - StartTrace));
    }
    else
    {
        Instigator.Weapon.AttachToBone(self, 'TopArmLock');
        SetRotation(rotator(EndEffect - StartTrace));
    }
    Dist = VSize(EndEffect - StartTrace);
    BeamEmitter(Emitters[0]).BeamDistanceRange.Min = Dist;
    BeamEmitter(Emitters[0]).BeamDistanceRange.Max = Dist;
}

simulated function vector GetBeamStart(vector X, vector Y, vector Z)
{
    if (Instigator.Controller.Handedness == 2.0) //GE: If the player has weapons off (what a fool!), calculate it ourselves
    {
        if (Instigator.Weapon.WeaponCentered())
            return Instigator.Location;
        else
            return Instigator.Location + Instigator.CalcDrawOffset(Instigator.Weapon) + EffectOffset.X * X + Instigator.Weapon.Hand * EffectOffset.Y * Y + EffectOffset.Z * Z;
    }
    bBoneAttach = True;
    return Instigator.Weapon.GetBoneCoords('TopArmLock').Origin;
}

defaultproperties
{
}
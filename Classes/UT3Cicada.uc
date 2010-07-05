/******************************************************************************
UT3Cicada

Creation date: 2008-05-02 20:50
Last change: Alpha 2
Copyright (c) 2008 and 2009, Wormbo and GreatEmerald
******************************************************************************/

class UT3Cicada extends ONSDualAttackCraft;

var(Sound) sound TargetLockSound;

simulated function DrawHUD(Canvas Canvas) //GE: Lock-on sound
{
	local vector X,Y,Z, Dir, LockedTarget;
	local float Dist,scale,xl,yl,posy;
	local PlayerController PC;
	local HudCDeathmatch H;

	local bool bIsLocked;
	local float DeltaTime;

	local string CoPilot;

	if ( !ONSDualACSideGun(Weapons[0]).bLocked )
		super.DrawHud(Canvas);

    DeltaTime = Level.TimeSeconds - LastHudRenderTime;
	LastHudRenderTime = Level.TimeSeconds;

	bIsLocked = ONSDualACSideGun(Weapons[0]).bLocked;

	PC = PlayerController(Owner);
	if (PC==None)
		return;

	H = HudCDeathmatch(PC.MyHud);
	if (H==None)
		return;

	if ( ONSDualACSideGun(Weapons[0]).bLocked )
	{
		if (bIsLocked != bLastLockType)	// Initialize the Crosshair
			ResetAnimation();

		Animate(Canvas,DeltaTime);

	    GetAxes(PC.GetViewRotation(), X,Y,Z);

	    LockedTarget = ONSDualACSideGun(Weapons[0]).LockedTarget;
	    if (OldLockedTarget != LockedTarget)
			PlaySound(TargetLockSound, SLOT_None, 2.0);

	    OldLockedTarget = LockedTarget;

		Dir = LockedTarget - Location;
		Dist = VSize(Dir);
		Dir = Dir/Dist;

	    if ( (Dir dot X) > 0.4 )
	    {
			// Draw the Locked on Symbol
			Dir = Canvas.WorldToScreen( LockedTarget );
			scale = float(Canvas.SizeX) / 1600;

			// new Stuff

			Canvas.SetDrawColor( 64,255,64,Value(SpinFade[0]) );
			CenterDraw(Canvas, SpinCircles[0], Dir.X, Dir.Y, Value(SpinScale[0])*Scale, Value(SpinScale[0])*Scale );
			Canvas.SetDrawColor(64,255,64,Value(SpinFade[1]) );
			CenterDraw(Canvas, SpinCircles[1], Dir.X, Dir.Y, Value(SpinScale[1])*Scale, Value(SpinScale[1])*Scale );

			Canvas.SetDrawColor(128,255,128,Value(BracketFade));
			DrawBrackets(Canvas,Dir.X,Dir.Y,Scale);
			DrawMissiles(Canvas,Dir.X,Dir.Y,Scale);

		}
	}

	bLastLockType = bIsLocked;

	HudMissileCount.Tints[0] = H.HudColorRed;
	HudMissileCount.Tints[1] = H.HudColorBlue;

	H.DrawSpriteWidget( Canvas, HudMissileCount );
	H.DrawSpriteWidget( Canvas, HudMissileIcon );
	HudMissileDigits.Value = ONSDualACSideGun(Weapons[0]).LoadedShotCount;
	H.DrawNumericWidget(Canvas, HudMissileDigits, DigitsBig);

	if (WeaponPawns[0]!=none && WeaponPawns[0].PlayerReplicationInfo!=None)
	{
		CoPilot = WeaponPawns[0].PlayerReplicationInfo.PlayerName;
		Canvas.Font = H.GetMediumFontFor(Canvas);
		Canvas.Strlen(CoPilot,xl,yl);
		posy = Canvas.ClipY*0.7;
		Canvas.SetPos(Canvas.ClipX-xl-5, posy);
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.DrawText(CoPilot);

		Canvas.Font = H.GetConsoleFont(Canvas);
        Canvas.StrLen(CoPilotLabel,xl,yl);
        Canvas.SetPos(Canvas.ClipX-xl-5,posy-5-yl);
		Canvas.SetDrawColor(160,160,160,255);
		Canvas.DrawText(CoPilotLabel);
	}

}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     TargetLockSound=Sound'UT3Vehicles.Cicada.Cicada_TargetLock01'
     DriverWeapons(0)=(WeaponClass=Class'UT3Style.UT3CicadaMissileLauncher')
     DriverWeapons(1)=(WeaponClass=Class'UT3Style.UT3CicadaMissileLauncher')
     PassengerWeapons(0)=(WeaponPawnClass=Class'UT3Style.UT3CicadaTurretPawn')
     IdleSound=Sound'UT3Vehicles.Cicada.Cicada_EngineLoop02'
     StartUpSound=Sound'UT3Vehicles.Cicada.Cicada_Start01'
     ShutDownSound=Sound'UT3Vehicles.Cicada.Cicada_Stop01'
     ExplosionSounds(0)=Sound'UT3Vehicles.Cicada.Cicada_Explode02'
     ExplosionSounds(1)=Sound'UT3Vehicles.Cicada.Cicada_Explode02'
     ExplosionSounds(2)=Sound'UT3Vehicles.Cicada.Cicada_Explode02'
     ExplosionSounds(3)=Sound'UT3Vehicles.Cicada.Cicada_Explode02'
     ExplosionSounds(4)=Sound'UT3Vehicles.Cicada.Cicada_Explode02'
     ImpactDamageSounds(0)=SoundGroup'UT3Vehicles.Cicada.Cicada_Collide'
     ImpactDamageSounds(1)=SoundGroup'UT3Vehicles.Cicada.Cicada_Collide'
     ImpactDamageSounds(2)=SoundGroup'UT3Vehicles.Cicada.Cicada_Collide'
     ImpactDamageSounds(3)=SoundGroup'UT3Vehicles.Cicada.Cicada_Collide'
     ImpactDamageSounds(4)=SoundGroup'UT3Vehicles.Cicada.Cicada_Collide'
     ImpactDamageSounds(5)=SoundGroup'UT3Vehicles.Cicada.Cicada_Collide'
     ImpactDamageSounds(6)=SoundGroup'UT3Vehicles.Cicada.Cicada_Collide'
     VehicleNameString="UT3 Cicada"
}

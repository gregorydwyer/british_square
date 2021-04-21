Function LoadMedia()
	Media.iLogo = MakeSprite( LoadImage("ffg-logo.png"), 0, 0)
	Sync()
	Media.iMusic =  LoadMusicOGG("trinket-stereo.ogg")
	SetMusicVolumeOGG(Media.iMusic, Flag.iMusicLevel)
	PlayMusicOGG(Media.iMusic, 1)
	Media.iTileSound = LoadSound("tile2.wav")
	Media.iClick = LoadSound("tile1.wav")
	Media.iSingleButton = Loadimage("Buttons/single.png")
	Media.iMultiButton = LoadImage("Buttons/multi.png")
	Media.iHtpButton = LoadImage("Buttons/how_to.png")
	Media.iSettingsButton = LoadImage("Buttons/settings.png")
	Media.iStartButton = LoadImage("Buttons/start.png")
	Media.iMenuButton = LoadImage("Buttons/menu.png")
	Media.iUpButton = LoadImage("Buttons/up.png")
	Media.iDownButton = LoadImage("Buttons/down.png")
	Media.iEasyButton = LoadImage("Buttons/easy.png")
	Media.iNormalButton = LoadImage("Buttons/normal.png")
	Media.iHardButton = LoadImage("Buttons/hard.png")
	Media.iMenuTick = LoadImage("Buttons/x_mark.png")
	Media.iMiniBlock = LoadImage("Buttons/miniblock.png")
	Media.iTile = LoadImage( "block.png" )
	Media.iColorChoice = LoadImage("Buttons/colorchoice.png")
	Media.iDifficultyChoice = LoadImage("Buttons/difficultychoice.png")
	Media.iHtp1 = LoadImage("htp.png")
	Media.iHtp2 = LoadImage("htp2.png")
	Media.iHtp3 = LoadImage("htp3.png")
	Media.iHtp4 = LoadImage("htp4.png")
	Media.iSettingsOverlay = LoadImage("settings-overlay.png")
	Media.iSingleOverlay = LoadImage("single-overlay.png")
	Media.iMultiOverlay = LoadImage("multi-overlay.png")
	Media.iGameboard = LoadImage("gameboard.png")
	Media.iTurnIndicator = LoadImage("Buttons/turn-indicator.png")
	Media.iFont = LoadImage("Arial.png")
	Media.iNumFont = LoadImage("Arial 2.png")
	Media.iOverlay = LoadImage("overlay.png")
	Media.iClearBoard = LoadSound( "clearboard.wav")
	Media.iQuitOverlay = LoadImage("quit-overlay.png")
	Media.iYesButton = LoadImage( "Buttons/yes.png")
	Media.iNoButton = LoadImage("Buttons/no.png")
	Media.iFanfare = LoadSound("fanfare.wav")
	Media.iFanfare2 = LoadSound("fanfare 2.wav")
	Media.iEndRound = LoadImage("endround.png")
	Media.iNoScore = LoadImage("noscore.png")
	Media.iRemoveAds = LoadImage("Buttons/ads.png")
	Sleep(1100)
	Media.iBackground = CreateSprite(LoadImage("background.png"))
EndFunction

Function CreateMainMenu()
	Media.iBackground = CreateSprite(LoadImage("background.png"))
	Button.iSinglePlayer = MakeSprite( Media.iSingleButton, 31, 324 )
	Button.iMultiplayer = MakeSprite( Media.iMultiButton, 31, 444 )
	Button.iHtp = MakeSprite( Media.iHtpButton, 31, 564 )
	Button.iSettings = MakeSprite( Media.iSettingsButton, 31, 684 )
	If GetInAppPurchaseAvailable (0) = 0
		Button.iRemoveAds = MakeSprite( Media.iRemoveAds, 189, 807)
	EndIf
EndFunction

Function MakeSprite( img, x, y)
	id = CreateSprite( img )
	SetSpritePosition( id, x, y)
EndFunction id

Function CreateSettingsFile()
	file = OpenToWrite( "settings", 0 )
	Flag.iSFXLevel = 100
	Flag.iMusicLevel = 70
	Flag.iReview = 0
	Flag.iVibrate = 1
	WriteInteger( file, Flag.iSFXLevel )
	WriteInteger( file, Flag.iMusicLevel )
	WriteInteger( file, Flag.iReview)
	WriteInteger( file, Flag.iVibrate)
	CloseFile( file )
EndFunction

Function ReadSettingsFile()
	file = OpenToRead( "settings" )
	Flag.iSFXLevel = ReadInteger( file )
	Flag.iMusicLevel = ReadInteger( file )
	Flag.iReview = ReadInteger(file)
	Flag.iVibrate = ReadInteger(file)
	CloseFile( file )
	SetMusicVolumeOGG(Media.iMusic, Flag.iMusicLevel)
	SetSoundSystemVolume(Flag.iSFXLevel)
EndFunction

Function ColorSet()
		Color[0].iColor = Red
		Color[1].iColor = Blue
		Color[2].iColor = Green
		Color[3].iColor = Yellow
		Color[4].iColor = Purple
		Color[5].iColor = Orange
		Color[6].iColor = Red
		Color[7].iColor = Blue
		Color[8].iColor = Green
		Color[9].iColor = Yellow
		Color[10].iColor = Purple
		Color[11].iColor = Orange	
	tmpx = 126
	tmpy =  456
	For i = 0 to 11
		Color[i].iTile = MakeSprite( Media.iMiniBlock, tmpx, tmpy )
		SetSpriteColor(Color[i].iTile, GetColorRed(Color[i].iColor), GetColorGreen(Color[i].iColor), GetColorBlue(Color[i].iColor), 255)		
		tmpx = tmpx + 63
		if tmpx => 504
			tmpx = 126
			tmpy = 567
		Endif
	Next i
EndFunction

Function MakeText( txt$, font, size, color, x, y)
	output = CreateText( txt$ )
	SetTextFontImage(output, font)
	SetTextAlignment(output, 1)
	SetTextSize(output, size)
	SetTextColor( output, GetColorRed(color), GetColorGreen(Color), GetColorBlue(color), 255)
	SetTextPosition( output, x, y)
EndFunction output

Function MakeParticles()
	LoadImage(1, "particle.png")
	CreateParticles ( 1, 150, 600 )
	SetParticlesImage ( 1, 1 )
	SetParticlesStartZone ( 1, -5, 0, 5, 0 )
	SetParticlesDirection ( 1, 0, -145 )
	SetParticlesAngle ( 1, 30 )
	SetParticlesFrequency ( 1, 30 )
	SetParticlesLife ( 1, 1 )
	SetParticlesSize ( 1, 20 )
	AddParticlesColorKeyFrame ( 1, 0, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 255)
	AddParticlesColorKeyFrame ( 1, 1, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 0)
	CreateParticles ( 2, 480, 600 )
	SetParticlesImage ( 2, 1 )
	SetParticlesStartZone ( 2, -5, 0, 5, 0 )
	SetParticlesDirection ( 2, 0, -145 )
	SetParticlesAngle ( 2, 30 )
	SetParticlesFrequency ( 2, 30 )
	SetParticlesLife ( 2, 1 )
	SetParticlesSize ( 2, 20 )
	AddParticlesColorKeyFrame ( 2, 0, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 255)
	AddParticlesColorKeyFrame ( 2, 1, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 0)
EndFunction

Function Click()
	If Flag.iVibrate = 1 then VibrateDevice(.005)
	PlaySound(Media.iClick)
EndFunction

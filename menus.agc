Function SettingsMenu()
	SettingsOverlay = MakeSprite( Media.iSettingsOverlay, 31, 324 )
	Button.iMenu =  MakeSprite( Media.iMenuButton, 252, 822 )
	Button.iSfxUp = MakeSprite( Media.iUpButton, 500, 390)
	Button.iSfxDown = MakeSprite( Media.iDownButton, 290, 390)
	Button.iMusicUp = MakeSprite(Media.iUpButton, 500, 500)
	Button.iMusicDown = MakeSprite(Media.iDownButton, 290, 500)
	If Flag.iVibrate = 1
		Button.iVibrate = MakeSprite(Media.iYesButton, 365, 590)
	ElseIf Flag.iVibrate = 0
		Button.iVibrate = MakeSprite(Media.iNoButton, 365, 590)
	EndIF
	restorepurchase = CreateSprite(Loadimage("restore_purchases.png"))
	SetSpritePosition(restorepurchase, 187, 742): SetSpriteVisible(restorepurchase, 0)
	IF Left(GetDeviceBaseName(), 3) = "ios" then SetSpriteVisible(restorepurchase, 1)
	music = MakeText(Str(Flag.iMusicLevel), Media.iNumFont, 85, White, 425, 490)	
	sfx = MakeText(Str(Flag.iSFXLevel), Media.iNumFont, 85, White, 425, 380)	
		Do
		If GetPointerReleased() = 1 
			If GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1 
				DeleteAllSprites()
				Click()
				Exit
			ElseIf GetSpriteHitTest( Button.iSfxUp, GetPointerX(), GetPointerY() ) = 1
				Click()
				IF Flag.iSFXLevel > 100  then Flag.iSFXLevel = 100
				IF Flag.iSFXLevel < 100  then Flag.iSFXLevel = Flag.iSFXLevel + 10
				DeleteText(sfx)
				sfx = MakeText(Str(Flag.iSFXLevel), Media.iNumFont, 85, White, 425, 380)
			ElseIf GetSpriteHitTest( Button.iSfxDown, GetPointerX(), GetPointerY() ) = 1
				Click()
				IF Flag.iSFXLevel < 0  then Flag.iSFXLevel = 0
				IF Flag.iSFXLevel > 0  then Flag.iSFXLevel = Flag.iSFXLevel - 10
				DeleteText(sfx)
				sfx = MakeText(Str(Flag.iSFXLevel), Media.iNumFont, 85, White, 425, 380)
			ElseIf GetSpriteHitTest( Button.iMusicUp, GetPointerX(), GetPointerY() ) = 1
				Click()
				IF Flag.iMusicLevel > 100  then Flag.iMusicLevel = 100 
				IF Flag.iMusicLevel < 100  then Flag.iMusicLevel = Flag.iMusicLevel + 10
				DeleteText(music)
				music = MakeText(Str(Flag.iMusicLevel), Media.iNumFont, 85, White, 425, 490)
			ElseIf GetSpriteHitTest( Button.iMusicDown, GetPointerX(), GetPointerY() ) = 1 
				Click()
				IF Flag.iMusicLevel < 0  then Flag.iMusicLevel = 0
				IF Flag.iMusicLevel > 0  then Flag.iMusicLevel = Flag.iMusicLevel - 10
				DeleteText(music)
				music = MakeText(Str(Flag.iMusicLevel), Media.iNumFont, 85, White, 425, 490)
			ElseIf GetSpriteHitTest( restorepurchase, GetPointerX(), GetPointerY() ) = 1 and GetSpriteVisible(restorepurchase) = 1
				InAppPurchaseRestore()
					If GetInAppPurchaseAvailable(0) = 1
						DeleteAdvert()
					Endif
				Click()
			ElseIf GetSpriteHitTest( Button.iVibrate, GetPointerX(), GetPointerY() ) = 1 
				Click()
				IF Flag.iVibrate = 0
					Flag.iVibrate = 1
				ElseIF Flag.iVibrate = 1
					Flag.iVibrate = 0
				EndIF
				DeleteSprite(Button.iVibrate)
				sync()
				If Flag.iVibrate = 1 then Button.iVibrate = MakeSprite(Media.iYesButton, 365, 590)
				sync()
				
				If Flag.iVibrate = 0 then Button.iVibrate = MakeSprite(Media.iNoButton, 365, 590)
				sync()
				
			Endif
		EndIf
		SetSoundSystemVolume(Flag.iSFXLevel)
		SetMusicVolumeOGG(Media.iMusic, Flag.iMusicLevel)
		If GetRawKeyPressed(27) = 1
			Click()
			DeleteAllSprites()
			DeleteAllText()
			Exit
		EndIf
			Sync()
		Loop
	file = OpenToWrite( "settings", 0 )
	WriteInteger( file, Flag.iSFXLevel )
	WriteInteger( file, Flag.iMusicLevel )
	CloseFile( file )
			
	DeleteAllSprites()
	DeleteAllText()
	CreateMainMenu()
	
EndFunction

Function HowtoPlay()
	DeleteAllSprites()
	SetAdvertVisible(0)
	Player[0].iColor = Red
	Player[1].iColor = Blue
	Flag.iCenterSquare = 1
	CreateSprite( Media.iGameboard )
	Button.iMenu = MakeSprite( Media.iMenuButton, 432, 30)
		tmp1 = 0
		tmp2 = 126
	For i = 0 to 24
		Gameboard[i].iFlag = 3
		Gameboard[i].iTile = CreateSprite( 0 )
		SetSpriteColorAlpha(Gameboard[i].itile, 0)
		SetSpritesize( GameBoard[i].iTile ,126, 126)
		SetSpritePosition( GameBoard[i].iTile , tmp1, tmp2)
		tmp1 = tmp1 + 126
		if tmp1 => 630 
			tmp1 = 0
			tmp2 = tmp2 + 126
		Endif
	Next i
	quithtp = 0
	
	Flag.iTurn = 0
	Overlay = MakeSprite( Media.iHtp1, 22, 779 )
	text = MakeText( "Welcome to British Square!" + chr(10) + "The game of outflanking" + chr(10) + "your opponent.", Media.iFont, 36, White, 315, 815)
	text2 = MakeText(   "If you already know how to play," + chr(10) + "tap menu to exit.", Media.iFont, 24, White, 315, 935)
	ttc = MakeText( "Tap to continue..." , Media.iFont, 24, White, 315, 1000)
	ext=1
	Repeat
	 quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
	Sync()
	Until GetPointerpressed() = 1 and ext = 1 and NOT GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1
	Click()
	ext=2
	DeleteText(text)
	DeleteText(text2)
	text = MakeText( "The object of the game" + chr(10) + "is to end each round with" + Chr(10) + "more of your tiles on the" + Chr(10) + "board than your opponent." , Media.iFont, 32, White, 315, 815)
	Repeat
		quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
	Sync()
	Until GetPointerPressed() = 1 and ext = 2 and NOT GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1
	Click()
	ext = 3
	DeleteAllText()
	text = MakeText( "Try tapping any square on the" + chr(10) + "board to place a tile." + chr(10) + chr(10) + "Note: The center square can not" + Chr(10) + "be played on the first turn." , Media.iFont, 32, White, 315, 815)
	Repeat
		quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
	Sync()
	Until GetPointerPressed() = 1 and ext = 3 and NOT GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1
	ext = 4
	HTPTurn(0)
	If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //Do nothing
	EndIf
	DeleteText(text)
	text = MakeText( "Next, your opponent" + chr(10) + "will play a turn." + chr(10) + "Tiles can be placed anywhere," + Chr(10) + "as long as the sides do not touch" + chr(10) + "an opponent's tile." , Media.iFont, 32, White, 315, 800)
	ttc = MakeText( "Tap to continue..." , Media.iFont, 24, White, 315, 1000)
	Repeat
		quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
	Sync()
	Until GetPointerReleased() = 1 and ext = 4 and NOT GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1
	Click()
	ext = 5
	HTPComputer(1)
	Sleep(1000)
	DeleteALLText()
	HTPOpen(0)
	text = MakeText( "Here you can see which spaces are" + chr(10) + "still available for you to play." + chr(10) + chr(10) + "Try playing a few turns" + chr(10) + "against the computer.", Media.iFont, 32, White, 315, 815)
	
	Do
	HTPTurn(0)
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //Do nothing
	EndIf
	quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //Do nothing
	EndIf
	open = HTPCheck()
	If open = 0 then Exit
	HTPComputer(1)
	quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
	HTPOpen(0)
	open = HTPCheck()
	If open = 0 then Exit
	quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
	Sync()
	Loop
	DeleteText(text)
	text = MakeText( "Now the computer will fill in" + chr(10) + "any remaining open spaces," + chr(10) + "and then all of the" + Chr(10) + "tiles will be counted.", Media.iFont, 32, White, 315, 815)
	HTPEnd()
	ttc = MakeText( "Tap to continue..." , Media.iFont, 24, White, 315, 1000)
	Repeat
		quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
		Sync()
	Until GetPointerPressed() = 1 and ext = 5 and NOT GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1
	Click()
	ext = 6
	DeleteTExt(text)
	text = MakeText( "The player with more tiles on" + chr(10) + "the board wins the round." + chr(10) + "The difference is added to" + Chr(10) + "the winner's score." + Chr(10) + "The first to 7 points wins the game.", Media.iFont, 32, White, 315, 815)
	Repeat
	quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
		Sync()
	Until GetPointerPressed() = 1 and ext = 6 and NOT GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1
	Click()
	ext = 7
	DeleteAllText()
	HTPEndRound()
	Repeat
		quithtp = ExitHTP()
	 If quithtp = 1
	 	DeleteAllSprites()
		DeleteAllText()
		CreateMainMenu()
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
		Sync()
	Until GetPointerPressed() = 1 and ext = 7 and NOT GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1
	Click()
	DeleteAllSprites()
	DeleteAllText()
	CreateMainMenu()
	SetAdvertVisible(1)
EndFunction

Function MultiMenu()
	MultiMenuTop:
	MultiOverlay = MakeSprite( Media.iMultiOverlay, 31, 324 )
	Button.iMenu =  MakeSprite( Media.iMenuButton, 252, 822 )
	Button.iStart = MakeSprite( Media.iStartButton, 252, 689 )
	p1 = MakeSprite( Media.iColorChoice, 126, 456 )
	p2 = MakeSprite( Media.iColorChoice, 189, 567 )
	ColorSet()
	For i = 0 to 5
		If Player[0].iColor = Color[i].iColor and NOT Player[1].iFlag = i
			SetSpritePosition(p1, GetSpriteX(Color[i].iTile), 456)
		EndIf
	Next i 
	For i = 6 to 11
		If Player[1].iColor = Color[i].iColor and NOT Player[0].iFlag = i - 6
			SetSpritePosition(p2, GetSpriteX(Color[i].iTile), 567)
		EndIf
	Next i
	Repeat
		If GetRawKeyPressed(27) = 1
		Click()
		DeleteAllSprites()
		DeleteAllText()
		Exit
	EndIf
	Sync()
	Until GetPointerPressed() = 1
	Do
		For i = 0 to 5
			If GetPointerReleased() = 1
				IF GetSpriteHitTest( Color[i].iTile, GetPointerX(), GetPointerY() ) = 1 and NOT Player[1].iFlag = i
					Click()
					tmpx = GetSpritex(Color[i].iTile)
					SetSpritePosition( p1, tmpx, 456 )
					Player[0].iColor = Color[i].iColor
					Player[0].iFlag = i
			
				EndIf
			Endif
		Next i
		For i = 6 to 11
			If GetPointerReleased() = 1
				IF GetSpriteHitTest( Color[i].iTile, GetPointerX(), GetPointerY() ) = 1 and NOT Player[0].iFlag = i - 6
					Click()
					tmpx = GetSpritex(Color[i].iTile)
					SetSpritePosition( p2, tmpx, 567 )
				 Player[1].iColor = Color[i].iColor
				 Player[1].iFlag = i - 6
				EndIf
			Endif
		Next i
	If GetPointerReleased() = 1
		If GetSpriteHitTest( Button.iStart, GetPointerX(), GetPointerY() ) = 1
			Click()
			Flag.iRound = 0
			GameOver = 0
			MultiplayerGame()
			IF Flag.iReview = 0
				GameCount = GameCount + 1
					If GameCount = 3
						Review()
						GameCount = 0
					EndIf
			EndIf	
			GoTo MultiMenuTop
		ElseIf GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1 
			Click()
			DeleteAllSprites()
			DeleteAllText()
			Exit
		EndIf
	EndIf
	If GetRawKeyPressed(27) = 1
		Click()
		DeleteAllSprites()
		DeleteAllText()
		Exit
	EndIf
		Sync()
	Loop
	CreateMainMenu()
EndFunction

Function SingleMenu()
	SingleMenuTop:
	SingleOverlay = MakeSprite( Media.iSingleOverlay, 31, 324 )
	Button.iMenu =  MakeSprite( Media.iMenuButton, 252, 822 )
	Button.iStart = MakeSprite( Media.iStartButton, 252, 713 )
	Button.iEasyButton = MakeSprite( Media.iEasyButton, 63, 639 )
	Button.iNormalButton = MakeSprite( Media.iNormalButton, 252, 639 )
	Button.iHardButton = MakeSprite( Media.iHardButton, 442, 639 )
	diff = MakeSprite( Media.iDifficultyChoice, 60, 630 )
	If Flag.iDifficulty = 0 then SetSpritePosition( diff, 60, 636)
	If Flag.iDifficulty = 1 then SetSpritePosition( diff, 249, 636)
	If Flag.iDifficulty = 2 then SetSpritePosition( diff, 439, 636)
	ColorSet()
	p1 = MakeSprite( Media.iColorChoice, 126, 456 )
	p2 = MakeSprite( Media.iColorChoice, 189, 567 )
	For i = 0 to 5
		If Player[0].iColor = Color[i].iColor
			SetSpritePosition(p1, GetSpriteX(Color[i].iTile), 456)
		EndIf
	Next i 
	For i = 6 to 11
		If Player[1].iColor = Color[i].iColor 
			SetSpritePosition(p2, GetSpriteX(Color[i].iTile), 567)
		EndIf
	Next i
	Repeat	
		If GetRawKeyPressed(27) = 1
		Click()
		DeleteAllSprites()
		DeleteAllText()
		Exit
	EndIf	
	Sync()
	Until GetPointerPressed() = 1
	Do
		For i = 0 to 5
			If GetPointerReleased() = 1
				IF GetSpriteHitTest( Color[i].iTile, GetPointerX(), GetPointerY() ) = 1 and NOT Player[1].iFlag = i
					Click()
					tmpx = GetSpritex(Color[i].iTile)
					SetSpritePosition( p1, tmpx, 456 )
					Player[0].iColor = Color[i].iColor
					Player[0].iFlag = i
				EndIf
			Endif
		Next i
		
		For i = 6 to 11
			If GetPointerReleased() = 1
				IF GetSpriteHitTest( Color[i].iTile, GetPointerX(), GetPointerY() ) = 1 and NOT Player[0].iFlag = i - 6
					Click()
					tmpx = GetSpritex(Color[i].iTile)
					SetSpritePosition( p2, tmpx, 567 )
				 Player[1].iColor = Color[i].iColor
				 Player[1].iFlag = i - 6
				EndIf
			Endif
		Next i
	
	If GetPointerReleased() = 1 
		If GetSpriteHitTest( Button.iHardButton, GetPointerX(), GetPointerY() ) = 1 
			If Flag.iDifficulty = 0 or Flag.iDifficulty = 1 
				Click()
				Flag.iDifficulty = 2
				SetSpritePosition( diff, 439, 636)
			EndIf
		ElseIf GetSpriteHitTest( Button.iNormalButton, GetPointerX(), GetPointerY() ) = 1
			If Flag.iDifficulty = 0 or Flag.iDifficulty = 2
				Click()
				Flag.iDifficulty = 1
				SetSpritePosition( diff, 249, 636)
			EndIf
		ElseIf GetSpriteHitTest( Button.iEasyButton, GetPointerX(), GetPointerY() ) = 1 
			If Flag.iDifficulty = 1 or Flag.iDifficulty = 2
				Click()
				Flag.iDifficulty = 0
				SetSpritePosition( diff, 60, 636)
			Endif
		EndIf
	EndIf
	If GetRawKeyPressed(27) = 1
		Click()
			DeleteAllSprites()
			Exit
	EndIf
	If GetPointerReleased() = 1
		If GetSpriteHitTest( Button.iStart, GetPointerX(), GetPointerY() ) = 1
			Click()
			Flag.iRound = 0
			GameOver = 0
			SingleplayerGame()
			IF Flag.iReview = 0
				GameCount = GameCount + 1
					If GameCount = 3
						Review()
						GameCount = 0
					EndIf
			EndIf
			GoTo SingleMenuTop		
		ElseIf GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1 
			Click()
			DeleteAllSprites()
			Exit
		EndIf
	EndIf
	If GetRawKeyPressed(27) = 1
		Click()
		DeleteAllSprites()
		DeleteAllText()
		Exit
	EndIf
		Sync()
	Loop
	CreateMainMenu()
EndFunction

Function QuitMenu()
	overlay = MakeSprite(Media.iQuitOverlay, 146, 336)
	Yesbutton = MakeSprite(Media.iYesButton, 168, 456)
	Nobutton = MakeSprite( Media.iNoButton, 343, 456)
	quit = 0
	cycle = 0
	Do 
		If GetPointerReleased() = 1 and cycle = 1
			If GetSpriteHitTest( Yesbutton, GetPointerX(), GetPointerY() ) = 1 
				Click()
				quit = 1
				Exit
			ElseIF GetSpriteHitTest( Nobutton, Getpointerx(), GetPointerY() ) = 1
				Click()
				quit = 0
				Exit
			EndIf
		EndIf
		cycle = 1
	Sync()
	Loop
	DeleteSprite( overlay )
	DeleteSprite( Yesbutton )
	DeleteSprite( Nobutton )
EndFunction quit

Function RemoveAds()
	SetSpriteVisible(Button.iRemoveAds, 0)
	overlay = MakeSprite( LoadImage("removeadsoverlay.png"), 31, 324 )
	yes = MakeSprite( LoadImage("Buttons/removeads.png"), 125, 500)
	no = MakeSprite( LoadImage( "Buttons/maybelater.png"), 125, 620)
	Do
	If GetPointerReleased() = 1 
		If GetSpriteHitTest( yes, GetPointerX(), GetPointerY() ) = 1
			Click()
			InAppPurchaseActivate(0) // 0 = id of product
				// Wait for user to purchase or cancel prompt
			While GetInAppPurchaseState() = 0
				Sync()
			EndWhile
				// User has canceled or already purchased
			If GetInAppPurchaseAvailable(0) < 1
				// Do nothing...
			ElseIf GetInAppPurchaseAvailable(0) = 1
				DeleteAdvert()
			Endif
		ElseIf GetSpriteHitTest( no, GetPointerX(), GetPointerY() ) = 1
			Click()
			If Flag.iReview = 0	
				Review()
			EndIf
				DeleteSprite(overlay)
				DeleteSprite(yes)
				DeleteSprite(no)
				SetSpriteVisible(Button.iRemoveAds, 1)
				Exit
		EndIf
	EndIf
		Sync()
	Loop
EndFunction

Function Review()
	overlay = MakeSprite( LoadImage("reviewoverlay.png"), 31, 324 )
	yes = MakeSprite( LoadImage("Buttons/idloveto.png"), 125, 470)
	maybe = MakeSprite( LoadImage( "Buttons/maybelater.png"), 125, 570)
	no = MakeSprite( LoadImage("Buttons/dontask.png"), 125, 670)
	cycle = 0
	Do
		If GetPointerReleased() = 1 and cycle = 1
			If GetSpriteHitTest( yes, GetPointerX(), GetPointerY() ) = 1
				Click()
				IF Left(GetDeviceBaseName(), 3) = "ios"
					OpenBrowser("itms-apps://itunes.apple.com/app/1110895135")
				ElseIF Left(GetDeviceBaseName(), 3) = "and"
					OpenBrowser("market://details?id=firstfrontiergames.britishsquare.apk")
				EndIf
				Flag.iReview = 1
				file = OpenToWrite( "settings", 0 )
					WriteInteger( file, Flag.iSFXLevel )
					WriteInteger( file, Flag.iMusicLevel )
					WriteInteger( file, Flag.iReview)
				CloseFile(file)
				Exit
			ElseIf GetSpriteHitTest( maybe, GetPointerX(), GetPointerY() ) = 1
				Click()
				Exit
			ElseIf GetSpriteHitTest( no, GetPointerX(), GetPointerY() ) = 1
				Click()
				Flag.iReview = 1
				file = OpenToWrite( "settings", 0 )
					WriteInteger( file, Flag.iSFXLevel )
					WriteInteger( file, Flag.iMusicLevel )
					WriteInteger( file, Flag.iReview)
				CloseFile(file)

				Exit
			EndIf
		EndIf
		Sync()
		cycle = 1
	Loop
	DeleteSprite(overlay)
	DeleteSprite(yes)
	DeleteSprite(maybe)
	DeleteSprite(no)
EndFunction

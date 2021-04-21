/**********************************************************************************************************
											GAMESETUP

 Sets up the game baord for a new round. 
 
 Each playable spot is created and put in the GameBoard array. Each spot is created in it's position 
 on the board with the sprite being transparent. The properties used to check playablity are initialized 
 for each spot. The center square is set to be unplayable since it cannot be played on the first turn. The 
 turn indicator sprite is created in the position for the starting player. 
***********************************************************************************************************/
Function Gamesetup()
	DeleteAllSprites()
	CreateSprite( Media.iGameboard )
	Button.iMenu =  MakeSprite( Media.iMenuButton, 252, 785 )
		
	For i = 0 to 24

		//Spaces are initially set to be playable by both player (iFlag = 3)
		Gameboard[i].iFlag = 3
		//Spaces are intially set to be "smart spots" which are used to increase difficulty of Normal AI (iScore)
		Gameboard[i].iScore = 1
		//Spaces are intially set to NOT be "hard spots" which are used to further increase difficulty of Hard AI (iHardTile)
		Gameboard[i].iHardTile = 0
		
		If i = 0 or i = 4 or i = 20 or i = 24
			Gameboard[i].iScore = 0
		EndIf
		
		Gameboard[i].iTile = CreateSprite( 0 )
		SetSpriteColorAlpha(Gameboard[i].itile, 0)
		SetSpritesize( GameBoard[i].iTile ,126, 126)
		xCoord = Mod(i,5)*126
		ycoord = (i/5)*126 + 126 
		SetSpritePosition( GameBoard[i].iTile , xCoord, yCoord)
	Next i
	
	Flag.iCenterSquare = 1
	IF Flag.iTurn = 0
		Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 249, 906)
	ElseIF Flag.iTurn = 1
		Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 331, 906)
	EndIf
EndFunction


/**********************************************************************************************
											MULTIPLAYERGAME
											
Controls the game flow for a game between two local human players. 							
**********************************************************************************************/
Function MultiplayerGame()
	If Flag.iRound = 0
		p1score = 0
		p2score = 0
		Flag.iTurn = 0
	EndIf
	NextRound:
	If GameOver = 1
		DeleteSprite(roundmessage)
		DeleteAllText()
		player1 = MakeText( Player[0].sName, Media.iFont, 38, Player[0].iColor, 131, 780)
		player2 = MakeText( Player[1].sName, Media.iFont, 38, Player[1].iColor, 498, 780)
		player1score = MakeText( Str(p1score), Media.iNumFont, 170, Player[0].iColor, 131, 840 ) 
		player2score = MakeText( Str(p2score), Media.iNumfont, 170, Player[1].iColor, 503, 840 )
		fanfare = PlaySound(Media.iFanfare)
		Overlay = MakeSprite( Media.iOverlay, 31, 220 )
		SetSpriteColorAlpha(Overlay, 220)
		winner = CreateText( "Player "  + Str(Flag.iTurn + 1) + " Wins!")
		SetTextColor(winner, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 255)
		SetTextAlignment( winner, 1) : SetTextFontImage( winner, Media.iFont ) : SetTextPosition( winner, 315, 280) : SetTextSize( winner, 60)
		tile = MakeSprite(Media.iTile, 258, 420) : SetSpriteColor( tile, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 255)
		spinflag = 1
		MakeParticles()
		
		Repeat
			IF spinflag = 1 
				SetSpriteAngle( tile, GetSpriteAngle(tile) + 1.125)
				If GetSpriteAngle(tile) > 15 and GetSpriteAngle(tile) < 60 then spinflag = 0
			ElseIf spinflag = 0
				SetSpriteAngle( tile, GetSpriteAngle(tile) - 1.125)
				If GetSpriteAngle(tile) > 300 And GetSpriteAngle(tile) < 345 then spinflag = 1
			EndIF
			Sync()
		Until GetPointerReleased() = 1
		
		If GetInAppPurchaseAvailable (0) = 0
			ShowFullscreenAdvertAdMob()
		EndIf
		
		Click()
		DeleteParticles(1)
		DeleteParticles(2)
		DeleteAllSprites()
		DeleteAllText()
		Media.iBackground = CreateSprite(LoadImage("background.png"))
		ExitFunction
	EndIf
	
	GameSetup()
	If NextRoundFlag = 1 Then PlaySound(Media.iClearBoard)
	DeleteAllText()
	NextRoundFlag = 0	
	player1 = MakeText( Player[0].sName, Media.iFont, 38, Player[0].iColor, 131, 780)
	player2 = MakeText( Player[1].sName, Media.iFont, 38, Player[1].iColor, 498, 780)
	player1score = MakeText( Str(p1score), Media.iNumFont, 170, Player[0].iColor, 131, 840 ) 
	player2score = MakeText( Str(p2score), Media.iNumfont, 170, Player[1].iColor, 503, 840 )
	Sync()
	Repeat
	If GetRawKeyPressed(27) = 1
		Click()
		quit = QuitMenu()
			IF quit = 1
				DeleteAllSprites()
				DeleteAllText()
				Media.iBackground = CreateSprite(LoadImage("background.png"))
				ExitFunction
			ElseIf quit = 0
				// do nothing, continue game
			EndIf
	Endif
		Sync()
	Until GetPointerPressed() = 1

	Do
		If NextRoundFlag = 1 then GoTo NextRound
		If GameOver = 1 then GoTo NextRound
		If GetPointerReleased() = 1
			PlayerTurn(Flag.iTurn)
			If GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1 
				Click()
				quit = QuitMenu()
				IF quit = 1
					DeleteAllSprites()
					DeleteAllText()
					Media.iBackground = CreateSprite(LoadImage("background.png"))
					ExitFunction
				ElseIf quit = 0
					// do nothing, continue game
				EndIf
			EndIf
		EndIf
		If GetRawKeyPressed(27) = 1
			Click()
			quit = QuitMenu()
				IF quit = 1
					DeleteAllSprites()
					DeleteAllText()
					Media.iBackground = CreateSprite(LoadImage("background.png"))
					ExitFunction
				ElseIf quit = 0
					// do nothing, continue game
				EndIf
		Endif
		Sync()
	Loop
EndFunction

/**********************************************************************************************
											SINGLEPLAYERGAME
											
 Controls the game flow for a game between a human player and a computer player. 
 
**********************************************************************************************/
Function SingleplayerGame()
	If Flag.iRound = 0
		p1score = 0
		p2score = 0
		Flag.iTurn = 0
	EndIf
	NextSingleRound:
	If GameOver = 1 
		DeleteSprite(roundmessage)
		DeleteAllText()
		player1 = MakeText( Player[0].sName, Media.iFont, 38, Player[0].iColor, 131, 780)
		player2 = MakeText( Player[1].sName, Media.iFont, 38, Player[1].iColor, 498, 780)
		player1score = MakeText( Str(p1score), Media.iNumFont, 170, Player[0].iColor, 131, 840 ) 
		player2score = MakeText( Str(p2score), Media.iNumfont, 170, Player[1].iColor, 503, 840 )
		Overlay = MakeSprite( Media.iOverlay, 31, 210 )
		SetSpriteColorAlpha(Overlay, 220)
		
		IF Flag.iTurn = 0
			winner = CreateText( "Player 1 Wins!")
			PlaySound(Media.iFanfare)
			SetTextColor(winner, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 255)
			SetTextAlignment( winner, 1) : SetTextFontImage( winner, Media.iFont ) : SetTextPosition( winner, 315, 280) : SetTextSize( winner, 60)
		ElseIf Flag.iTurn = 1
			winner = CreateText( "The" + chr(10) + "Computer" + chr(10) + "Wins!")
			PlaySound(Media.iFanfare2)
			SetTextColor(winner, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 255)
			SetTextAlignment( winner, 1) : SetTextFontImage( winner, Media.iFont ) : SetTextPosition( winner, 315, 240) : SetTextSize( winner, 60)
		EndIf
		
		IF Flag.iTurn = 0 then tile = MakeSprite(Media.iTile, 258, 420)
		IF Flag.iTurn = 1 then tile = MakeSprite(Media.iTile, 258, 460)
		SetSpriteColor( tile, GetColorRed(Player[Flag.iturn].icolor), GetColorGreen(Player[Flag.iturn].icolor), GetColorBlue(Player[Flag.iturn].icolor), 255)
		spinflag = 1
		MakeParticles()
		
		Repeat
			IF spinflag = 1 
				SetSpriteAngle( tile, GetSpriteAngle(tile) + 1.125)
				If GetSpriteAngle(tile) > 15 and GetSpriteAngle(tile) < 60 then spinflag = 0
			ElseIf spinflag = 0
				SetSpriteAngle( tile, GetSpriteAngle(tile) - 1.125)
				If GetSpriteAngle(tile) > 300 And GetSpriteAngle(tile) < 345 then spinflag = 1
			EndIF
			Sync()
		Until GetPointerReleased() = 1
		
		If GetInAppPurchaseAvailable (0) = 0
			ShowFullscreenAdvertAdMob()
		EndIf			
		DeleteParticles(1)
		DeleteParticles(2)
		Click()
		DeleteAllSprites()
		DeleteAllText()
		Media.iBackground = CreateSprite(LoadImage("background.png"))
		ExitFunction
	EndIf
	
	GameSetup()
	IF Flag.iDifficulty = 2 then MakeHardTiles()
	DeleteAllText()
	If NextRoundFlag = 1 Then PlaySound(Media.iClearBoard)
	NextRoundFlag = 0
	player1 = MakeText( "Player 1", Media.iFont, 38, Player[0].iColor, 131, 780)
	player2 = MakeText( "Computer", Media.iFont, 38, Player[1].iColor, 498, 780)
	player1score = MakeText( Str(p1score), Media.iNumFont, 170, Player[0].iColor, 131, 840 ) 
	player2score = MakeText( Str(p2score), Media.iNumfont, 170, Player[1].iColor, 503, 840 )
	Sync()
	IF Flag.iTurn = 0
		Repeat
			If GetRawKeyPressed(27) = 1
				Click()
				quit = QuitMenu()
				IF quit = 1
					DeleteAllSprites()
					DeleteAllText()
					Media.iBackground = CreateSprite(LoadImage("background.png"))
					ExitFunction
				ElseIf quit = 0
					// do nothing, continue game
				EndIf
			EndIf
			Sync()
		Until GetPointerPressed() = 1
	EndIf
	
	Do
		If Flag.iTurn = 1
			If Flag.iDifficulty = 0 then ComputerEasy_MF(Flag.iTurn)
			IF Flag.iDifficulty = 1
				smarttiles = 0
				
				For i = 0 to 24
					If GameBoard[i].iScore = 1 then smarttiles = 1
				Next i
				
				If smarttiles = 1 then ComputerNormal(Flag.iTurn)
				If smarttiles = 0 then ComputerEasy_MF(Flag.iTurn)
			EndIf
			IF Flag.iDifficulty = 2
				MakeHardTiles()
				ComputerHard(Flag.iTurn)
			EndIf
		EndIF
		
		If NextRoundFlag = 1 then GoTo NextSingleRound
		If GameOver = 1 then GoTo NextSingleRound
		If GetPointerReleased() = 1
			If GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1 
				Click()
				quit = QuitMenu()
				IF quit = 1
					DeleteAllSprites()
					DeleteAllText()
					Media.iBackground = CreateSprite(LoadImage("background.png"))
					ExitFunction
				ElseIf quit = 0
					// do nothing, continue game
				EndIf
			ElseIF Flag.iTurn = 0 
				PlayerTurn(Flag.iTurn)	
			EndIf
		EndIf
		If GetRawKeyPressed(27) = 1
			Click()
			quit = QuitMenu()
			If quit = 1
					DeleteAllSprites()
					DeleteAllText()
					Media.iBackground = CreateSprite(LoadImage("background.png"))
					ExitFunction
			ElseIf quit = 0
					//do nothing
			EndIf
		Endif
		If NextRoundFlag = 1 then GoTo NextSingleRound
		If GameOver = 1 then GoTo NextSingleRound
		Sync()
	Loop
EndFunction

/**********************************************************************************************
											PLAYERTURN
 Checks if a clicked spot is a valid move and if it is, changes the tile sprite to the current 
 players sprite.								
**********************************************************************************************/
Function PlayerTurn(id)
	For i = 0 to 24
		If i = 12 and Flag.iCenterSquare = 1 then GoTo CenterSquare						//Center square cannot be played on first turn, jump past tile laying code 
		If GetSpriteHitTest( GameBoard[i].iTile, GetPointerX(), GetPointerY() ) = 1		// Find tile that was clicked 
			If GameBoard[i].iFlag = 3 or Gameboard[i].iFlag = id 						// Verifies that spot is playable
				Player[Flag.iTurn].iTile = MakeSprite( Media.iTile, GetSpriteX(Gameboard[i].iTile) + 6, GetSpriteY(Gameboard[i].iTile) + 6)
				Playsound(Media.iTileSound)
				VibrateDevice(.005)
				SetSpriteColor( Player[Flag.iTurn].iTile,  GetColorRed(Player[Flag.iTurn].iColor), 
								GetColorGreen(Player[Flag.iTurn].iColor), GetColorBlue(Player[Flag.iTurn].iColor), 255)
				Sync()
				GameBoard[i].iFlag = 4 + Flag.iTurn
				GameBoard[i].iScore = 0
				GameBoard[i].iHardTile = 0
				//This section makes the limits the squares to the same player
				ChangeTileScore( i, id)
				ChangeTurns()
				If Flag.iCenterSquare = 1 then Flag.iCenterSquare = 0
			  Exit
			EndIf 
		EndIf
		CenterSquare:
	Next i
	DeleteSprite(Button.iTurnIndicator)
	If Flag.iTurn = 0 then Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 249, 906)
	If Flag.iTurn = 1 then Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 331, 906)
	Sync()
EndFunction

/**********************************************************************************************
											CHANGETURNS

 Checks if either player or both players are out of playable spots. If one player is out of moves, 
 the round will autocomplete. Otherwise, if both players still have playable spots, the turn is changed.  
 									
**********************************************************************************************/
Function ChangeTurns() 
	p1 = 0
	p2 = 0
		For i = 0 to 24
			If Gameboard[i].iFlag = 3
				p1 = 1
				p2 = 1
			EndIf
			If Gameboard[i].iFlag = 0 
				p1 = 1
			ElseIf Gameboard[i].iFlag = 1 
				p2 = 1
			EndIf
		Next i
		If p1 = p2
			If Flag.iTurn = 0
				Flag.iTurn = 1
			ElseIf Flag.iTurn = 1
				Flag.iTurn = 0
			EndIf
		ElseIf p1 = 1 and p2 = 0
			Flag.iTurn = 0
				If roundmessage = Player[Flag.iTurn].iTile
					//Do nothing
				Else
					DeleteSprite(roundmessage)
				EndIf
				roundmessage = MakeSprite( Media.iEndRound, 145, 343)
				Sync()
				SetSpriteDepth(roundmessage, 2)
				ComputerEasy_MF(Flag.iTurn)
		ElseIf p2 = 1 and p1 = 0
			Flag.iTurn = 1
				If roundmessage = Player[Flag.iTurn].iTile
					//Do nothing
				Else
					DeleteSprite(roundmessage)
				EndIf
				roundmessage = MakeSprite( Media.iEndRound, 145, 343)
				Sync()
				SetSpriteDepth(roundmessage, 2)
				ComputerEasy_MF(Flag.iTurn)
		Endif
		IF p1 = 0 and p2 = 0
			If roundmessage = Player[Flag.iTurn].iTile
				//Do nothing
			Else
				DeleteSprite(roundmessage)
			EndIf
				roundmessage = MakeSprite( Media.iEndRound, 145, 343)
				Sync()
				SetSpriteDepth(roundmessage, 2)		
			EndRound()
		EndIf
EndFunction

/**********************************************************************************************
											ENDROUND

 This function is executed at the end of a round. The number of placed tiles by each player is counted 
 and the net score is added to the winning player's total score. If a player has won the match, the 
 GameOver flag is switched. 
 				
**********************************************************************************************/		
Function EndRound()
	p1 = 0
	p2 = 0
	
	For i = 0 to 24
		if GameBoard[i].iFlag = 4 then p1 = p1+1
		if GameBoard[i].iFlag = 5 then p2 = p2+1
	Next i
	
	IF p1 > p2 
		p1Score = p1score + (p1-p2)
		score = MakeText("+"+Str(p1-p2), Media.iNumFont, 100, Player[0].iColor, 305, 430)
		SetTextDepth(score, 1)
		Flag.iTurn = 1
	ElseIf p2 > p1 
		p2Score = p2score + (p2-p1)
		score = MakeText("+"+Str(p2-p1), Media.iNumFont, 100, Player[1].iColor, 305, 430)
		SetTextDepth(score, 1)
		Flag.iTurn = 0
	ElseIf p1 = p2
		//No Score is awarded for the round
		score = MakeSprite(Media.iNoScore, 145, 450)
		SetSpriteDepth( score, 1)
	Endif
	
	If p1score < 7 and p2score < 7
		NextRoundFlag = 1
	Elseif p1score >= 7 
		GameOver = 1
		Flag.iTurn = 0
	ElseIf p2score >= 7
		GameOver = 1
		Flag.iTurn = 1
	EndIf
	MakeHardTiles()
	Sync()
	Sleep(1700)
EndFunction	

/**********************************************************************************************
											COMPUTEREASY_MF
											
**********************************************************************************************/
Function ComputerEasy_MF(id) 
	sleep (750)
	
	// An array is created containing the open spaces' numbers 
	spot_count = 0
	
	for i = 0 to 24 
		if GameBoard[i].iFlag = 3 or GameBoard[i].iFlag = id 
			available_spots[spot_count] = i 
			spot_count = spot_count + 1	
			If spot_count => 24 then spot_count=24
		EndIf
	Next i 
	
	Do 
		i = available_spots[Random(0,spot_count)]
			If i = 12 and Flag.iCenterSquare = 1 then GoTo CenterSquareMF
				If GameBoard[i].iFlag = 3 or Gameboard[i].iFlag = id //Verifies if spot is playable
					Player[Flag.iTurn].iTile = MakeSprite( Media.iTile, GetSpriteX(Gameboard[i].iTile) + 6, GetSpriteY(Gameboard[i].iTile) + 6)
					Playsound(Media.iTileSound)
					SetSpriteColor( Player[Flag.iTurn].iTile,  GetColorRed(Player[Flag.iTurn].iColor), GetColorGreen(Player[Flag.iTurn].iColor), GetColorBlue(Player[Flag.iTurn].iColor), 255)
					Sync()
					GameBoard[i].iFlag = 4 + Flag.iTurn
					//This section makes the limits the squares to the same player
					ChangeTileScore( i, id)
					ChangeTurns()
					If Flag.iCenterSquare = 1 then Flag.iCenterSquare = 0
					DeleteSprite(Button.iTurnIndicator)
						If Flag.iTurn = 0 then Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 249, 906)
						If Flag.iTurn = 1 then Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 331, 906)
						Sync()
				  ExitFunction
				EndIf 
			CenterSquareMF:	
		Sync()
		Loop	
EndFunction 

/**********************************************************************************************
											COMPUTERNORMAL
											
**********************************************************************************************/	
Function ComputerNormal(id) //If difficulty is set to Normal and spaces with .iScore = 1 (Smart Tiles) exist, this function does the computer turn.
	Sleep(750)
	
	// An array is created containing the open spaces' numbers 
	spot_count = 0
	for i = 0 to 24 
		if GameBoard[i].iFlag = 3 or Gameboard[i].iFlag = id 
			available_spots[spot_count] = i 
			spot_count = spot_count + 1
			If spot_count => 24 then spot_count=24
		EndIf
	Next i 
	
	Do
		i = available_spots[Random(0,spot_count)]
			If i = 12 and Flag.iCenterSquare = 1 then GoTo CenterSquareNormal
			If GameBoard[i].iScore = 1
				If GameBoard[i].iFlag = 3 or Gameboard[i].iFlag = id //Verifies if spot is playable
					Player[Flag.iTurn].iTile = MakeSprite( Media.iTile, GetSpriteX(Gameboard[i].iTile) + 6, GetSpriteY(Gameboard[i].iTile) + 6)
					Playsound(Media.iTileSound)
					SetSpriteColor( Player[Flag.iTurn].iTile,  GetColorRed(Player[Flag.iTurn].iColor), GetColorGreen(Player[Flag.iTurn].iColor), GetColorBlue(Player[Flag.iTurn].iColor), 255)
					Sync()
					GameBoard[i].iFlag = 4 + Flag.iTurn
					GameBoard[i].iScore = 0
					GameBoard[i].iHardTile = 0
					//This section makes the limits the squares to the same player
					ChangeTileScore( i, id)
					ChangeTurns()
					If Flag.iCenterSquare = 1 then Flag.iCenterSquare = 0
					DeleteSprite(Button.iTurnIndicator)
						If Flag.iTurn = 0 then Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 249, 906)
						If Flag.iTurn = 1 then Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 331, 906)
						Sync()					
				  ExitFunction
				EndIf 
			EndIf
		CenterSquareNormal:	
	Sync()
	Loop
EndFunction

/**********************************************************************************************
											COMPUTERHARD
											
**********************************************************************************************/
Function ComputerHard(id) //If difficulty is set to Hard and spaces with .iHardTiles = 1 (Hard Smart Tiles) exist, this function does the computer turn.
	Sleep(750)
		
	// An array is created containing the open spaces' numbers 
	spot_count = 0
	hard_count = 5
	for i = 0 to 24 
		if GameBoard[i].iHardTile = hard_count
			available_spots[spot_count] = i 
			spot_count = spot_count + 1
			If spot_count => 24 then spot_count=24
		EndIf
		If i = 24 and spot_count = 0
			hard_count = hard_count - 1
			i = -1
		EndIf
	Next i 
	
	Do
		i = available_spots[Random(0,spot_count)]
			If i = 12 and Flag.iCenterSquare = 1 then GoTo CenterSquareHard
			If GameBoard[i].iFlag = 3 or Gameboard[i].iFlag = id //Verifies if spot is playable
				Player[Flag.iTurn].iTile = MakeSprite( Media.iTile, GetSpriteX(Gameboard[i].iTile) + 6, GetSpriteY(Gameboard[i].iTile) + 6)
				Playsound(Media.iTileSound)
				SetSpriteColor( Player[Flag.iTurn].iTile,  GetColorRed(Player[Flag.iTurn].iColor), GetColorGreen(Player[Flag.iTurn].iColor), GetColorBlue(Player[Flag.iTurn].iColor), 255)
				Sync()
				GameBoard[i].iFlag = 4 + Flag.iTurn
				GameBoard[i].iScore = 0
				GameBoard[i].iHardTile = 0
				//This section makes the limits the squares to the same player
				ChangeTileScore( i, id)
				// This next section sets up the strategy for the Hard AI
				ChangeTurns()
				
				If Flag.iCenterSquare = 1 then Flag.iCenterSquare = 0
				DeleteSprite(Button.iTurnIndicator)
					If Flag.iTurn = 0 then Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 249, 906)
					If Flag.iTurn = 1 then Button.iTurnIndicator = MakeSprite(Media.iTurnIndicator, 331, 906)
					Sync()	
			  ExitFunction
			EndIf 
			CenterSquareHard:	
	Sync()
	Loop
EndFunction

/**********************************************************************************************
											MAKEHARDTILES
											
**********************************************************************************************/
Function MakeHardTiles()
	For i = 0 to 24
		GameBoard[i].iHardTile = 0
		//Checks to see if space is a playable computer spot
		If GameBoard[i].iFlag = 3 or GameBoard[i].iFlag = 1
			GameBoard[i].iHardTile = GameBoard[i].iHardTile + 1
			//Next section deals with counting the tiles that it will block off
			if i >= 5
				if GameBoard[i-5].iFlag = 3 or GameBoard[i-5].iFlag = 0 //or GameBoard[i-5].iFlag = 1
				GameBoard[i].iHardTile = GameBoard[i].iHardTile + 1
				EndIf
			Endif
			If i <= 19 
				If GameBoard[i+5].iFlag = 3 or GameBoard[i+5].iFlag = 0 //or GameBoard[i+5].iFlag = 1
					GameBoard[i].iHardTile = GameBoard[i].iHardTile + 1
				EndIf
			EndIf
			If i >= 1 and NOT i = 5 and NOT i = 10 and NOT i = 15 and NOT i=20
				If GameBoard[i-1].iFlag = 3 or GameBoard[i-1].iFlag = 0 //or GameBoard[i-1].iFlag = 1
					GameBoard[i].iHardTile = GameBoard[i].iHardTile + 1
				EndIf
			EndIf
			If i <= 23 and NOT i = 19 and NOT i = 14 and NOT i = 9 and NOT i = 4
				If GameBoard[i+1].iFlag = 3 or GameBoard[i+1].iFlag = 0 //or GameBoard[i+1].iFlag = 1
					GameBoard[i].iHardTile = GameBoard[i].iHardTile + 1
				EndIf
			EndIf
		//Redundant as failsafe, if the spot already has a tile on it, this resets the hard tile flag.
		ElseIF GameBoard[i].iFlag = 0 or GameBoard[i].iFlag >= 4 
			GameBoard[i].iHardTile = 0
		EndIf
	Next i 
EndFunction

/**********************************************************************************************
											CHANGETILESCORE

 When a tile has been placed, this function changes the playablity properties of the tiles 
 surrouding the placed tile. 
 			
**********************************************************************************************/
Function ChangeTileScore( i, id)
	If i >= 5
		GameBoard[i-5].iScore = 0
		GameBoard[i-5].iHardTile = 0
		If GameBoard[i-5].iFlag = 3 or GameBoard[i-5].iFlag = id
			GameBoard[i-5].iFlag = id
		ElseIf NOT GameBoard[i-5].iFlag = 4 and NOT GameBoard[i-5].iFlag = 5 
			GameBoard[i-5].iFlag = 6
		EndIf
	Endif
	If i <= 19
		Gameboard[i+5].iScore = 0
		Gameboard[i+5].iHardTile = 0
		If GameBoard[i+5].iFlag = 3 or GameBoard[i+5].iFlag = id
			GameBoard[i+5].iFlag = id
		ElseIf NOT GameBoard[i+5].iFlag = 4 and NOT GameBoard[i+5].iFlag = 5
			GameBoard[i+5].iFlag = 6
		EndIf
	Endif
	If i >= 1 and NOT i = 5 and NOT i = 10 and NOT i = 15 and NOT i = 20
		GameBoard[i-1].iScore = 0
		GameBoard[i-1].iHardTile = 0
		If GameBoard[i-1].iFlag = 3 or GameBoard[i-1].iFlag = id
			GameBoard[i-1].iFlag = id
		ElseIf NOT GameBoard[i-1].iFlag = 4 and NOT GameBoard[i-1].iFlag = 5
			GameBoard[i-1].iFlag = 6
		EndIf
	EndIf
	If i <= 23 and NOT i = 4 and NOT i = 9 and NOT i = 14 and NOT i = 19
		GameBoard[i+1].iScore = 0
		GameBoard[i+1].iHardTile = 0
		If GameBoard[i+1].iFlag = 3 or GameBoard[i+1].iFlag = id
			GameBoard[i+1].iFlag = id
		ElseIf NOT GameBoard[i+1].iFlag = 4 and NOT GameBoard[i+1].iFlag = 5
			GameBoard[i+1].iFlag = 6
		EndIf
	EndIf	
EndFunction

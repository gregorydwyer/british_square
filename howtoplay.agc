Function HTPTurn(id)
	Do 
		tmp = 0
	 If GetPointerReleased() = 1
		For i = 0 to 24
			If i = 12 and Flag.iCenterSquare = 1 then GoTo CenterSquareHTP
			If GetSpriteHitTest( GameBoard[i].iTile, GetPointerX(), GetPointerY() ) = 1	
				If GameBoard[i].iFlag = 3 or Gameboard[i].iFlag = id //Verifies if spot is playable
					Player[id].iTile = MakeSprite( Media.iTile, GetSpriteX(Gameboard[i].iTile) + 6, GetSpriteY(Gameboard[i].iTile) + 6)
					Playsound(Media.iTileSound)
					SetSpriteColor( Player[id].iTile,  GetColorRed(Player[id].iColor), GetColorGreen(Player[id].iColor), GetColorBlue(Player[id].iColor), 255)
					Sync()
					GameBoard[i].iFlag = 4 + id
					GameBoard[i].iScore = 0
					//This section makes the limits the squares to the same player
					If i >= 5
						GameBoard[i-5].iScore = 0
						If GameBoard[i-5].iFlag = 3 or GameBoard[i-5].iFlag = id
							GameBoard[i-5].iFlag = id
						ElseIf NOT GameBoard[i-5].iFlag = 4 and NOT GameBoard[i-5].iFlag = 5 
							GameBoard[i-5].iFlag = 6
						EndIf
					Endif
					If i <= 19
						Gameboard[i+5].iScore = 0
						If GameBoard[i+5].iFlag = 3 or GameBoard[i+5].iFlag = id
							GameBoard[i+5].iFlag = id
						ElseIf NOT GameBoard[i+5].iFlag = 4 and NOT GameBoard[i+5].iFlag = 5
							GameBoard[i+5].iFlag = 6
						EndIf
					Endif
					If i >= 1 and NOT i = 5 and NOT i = 10 and NOT i = 15 and NOT i = 20
						GameBoard[i-1].iScore = 0
						If GameBoard[i-1].iFlag = 3 or GameBoard[i-1].iFlag = id
							GameBoard[i-1].iFlag = id
						ElseIf NOT GameBoard[i-1].iFlag = 4 and NOT GameBoard[i-1].iFlag = 5
							GameBoard[i-1].iFlag = 6
						EndIf
					EndIf
					If i <= 23 and NOT i = 4 and NOT i = 9 and NOT i = 14 and NOT i = 19
						GameBoard[i+1].iScore = 0
						If GameBoard[i+1].iFlag = 3 or GameBoard[i+1].iFlag = id
							GameBoard[i+1].iFlag = id
						ElseIf NOT GameBoard[i+1].iFlag = 4 and NOT GameBoard[i+1].iFlag = 5
							GameBoard[i+1].iFlag = 6
						EndIf
					EndIf
					If Flag.iCenterSquare = 1 then Flag.iCenterSquare = 0
					Sync()
				  ExitFunction
				EndIf 
			EndIf
			CenterSquareHTP:
		Next i
	EndIf
		quithtp = ExitHTP()
	 If quithtp = 1
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	EndIf
	Sync()
	Loop
EndFunction

Function HTPComputer(id)
	Sleep(750)
	Do
		tmp = 0
		i = Random(0, 24)
			If i = 12 and Flag.iCenterSquare = 1 then GoTo CenterHTPComp
				If GameBoard[i].iFlag = 3 or Gameboard[i].iFlag = id //Verifies if spot is playable
					Player[id].iTile = MakeSprite( Media.iTile, GetSpriteX(Gameboard[i].iTile) + 6, GetSpriteY(Gameboard[i].iTile) + 6)
					Playsound(Media.iTileSound)
					SetSpriteColor( Player[id].iTile,  GetColorRed(Player[id].iColor), GetColorGreen(Player[id].iColor), GetColorBlue(Player[id].iColor), 255)
					Sync()
					GameBoard[i].iFlag = 4 + id
					//This section makes the limits the squares to the same player
					If i >= 5
						If GameBoard[i-5].iFlag = 3 or GameBoard[i-5].iFlag = id
							GameBoard[i-5].iFlag = id
						ElseIf NOT GameBoard[i-5].iFlag = 4 and NOT GameBoard[i-5].iFlag = 5 
							GameBoard[i-5].iFlag = 6
						EndIf
					Endif
					If i <= 19
						If GameBoard[i+5].iFlag = 3 or GameBoard[i+5].iFlag = id
							GameBoard[i+5].iFlag = id
						ElseIf NOT GameBoard[i+5].iFlag = 4 and NOT GameBoard[i+5].iFlag = 5
							GameBoard[i+5].iFlag = 6
						EndIf
					Endif
					If i >= 1 and NOT i = 5 and NOT i = 10 and NOT i = 15 and NOT i = 20
						If GameBoard[i-1].iFlag = 3 or GameBoard[i-1].iFlag = id
							GameBoard[i-1].iFlag = id
						ElseIf NOT GameBoard[i-1].iFlag = 4 and NOT GameBoard[i-1].iFlag = 5
							GameBoard[i-1].iFlag = 6
						EndIf
					EndIf
					If i <= 23 and NOT i = 4 and NOT i = 9 and NOT i = 14 and NOT i = 19
						If GameBoard[i+1].iFlag = 3 or GameBoard[i+1].iFlag = id
							GameBoard[i+1].iFlag = id
						ElseIf NOT GameBoard[i+1].iFlag = 4 and NOT GameBoard[i+1].iFlag = 5
							GameBoard[i+1].iFlag = 6
						EndIf
					EndIf
				  ExitFunction
				EndIf 
			CenterHTPComp:	
		quithtp = ExitHTP()
	 If quithtp = 1
		ExitFunction
	 ElseIf quithtp = 0
		 //do nothing
	Endif
	Sync()
	Loop
EndFunction

Function HTPOpen(id)
	For i = 0 to 24
		DeleteSprite( Gameboard[i].iColor)
		If GameBoard[i].iFlag = id or GameBoard[i].iFlag = 3
			GameBoard[i].iColor = MakeSprite( Media.iTile, GetSpriteX(Gameboard[i].iTile) + 6, GetSpriteY(GameBoard[i].iTile) + 6)
			SetSpriteColor( GameBoard[i].iColor,  GetColorRed(Player[id].iColor), GetColorGreen(Player[id].iColor), GetColorBlue(Player[id].iColor), 80)
		EndIf
	Next i
EndFunction

Function HTPCheck()
	open = 1
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
			open = 1
		ElseIf p1 = 1 and p2 = 0
			open = 0
		ElseIf p2 = 1 and p1 = 0
			open = 0
	Endif	
	IF p1 = 0 and p2 = 0
			open = 0
	EndIf
EndFUnction( open )

Function HTPEnd()
	Do
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
		If p1 = 1 and p2 = 0
			DeleteSprite(roundmessage)
			roundmessage = MakeSprite( Media.iEndRound, 145, 343)
			SetSpriteDepth(roundmessage, 2)
			HTPComputer(0)
		ElseIf p2 = 1 and p1 = 0
			DeleteSprite(roundmessage)
			roundmessage = MakeSprite( Media.iEndRound, 145, 343)
			SetSpriteDepth(roundmessage, 2)
			HTPComputer(1)
		Endif
		IF p1 = 0 and p2 = 0
			DeleteSprite(roundmessage)
			roundmessage = MakeSprite( Media.iEndRound, 145, 343)
			SetSpriteDepth(roundmessage, 2)			
			Exit
		EndIf
	Loop
EndFunction
	
Function HTPEndRound()
	Flag.iRound = Flag.iRound + 1
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
		text = MakeText( "Congratulations! You won the round!" + chr(10) + "The points above would be added to" + chr(10) + "your score and a new round would start." + Chr(10) + "Now, go try your luck against" + Chr(10) + "the computer, or play with a friend!", Media.iFont, 28, White, 315, 810)
		ttc = MakeText( "Tap to Exit." , Media.iFont, 24, White, 315, 1000)
	ElseIf p2 > p1 
		p2Score = p2score + (p2-p1)
		score = MakeText("+"+Str(p2-p1), Media.iNumFont, 100, Player[1].iColor, 305, 430)
		SetTextDepth(score, 1)
		text = MakeText( "Oh No! Your opponent won the round!" + chr(10) + "The points above would be added to" + chr(10) + "their score and a new round would start." + Chr(10) + "Now, go try your luck against" + Chr(10) + "the computer, or play with a friend!", Media.iFont, 28, White, 315, 810)
		ttc = MakeText( "Tap to Exit." , Media.iFont, 24, White, 315, 1000)
	ElseIf p1 = p2
		//No Score is awarded for the round
		score = MakeSprite(Media.iNoScore, 145, 450)
		SetSpriteDepth( score, 1)
		text = MakeText( "No points for this round!" + chr(10) + "If you had scored your points would" + chr(10) + "be added to your score and" + Chr(10) + "a new round would start." + Chr(10) + "Now, go try your luck against" + Chr(10) + "the computer, or play with a friend!", Media.iFont, 28, White, 315, 810)
		ttc = MakeText( "Tap to Exit." , Media.iFont, 24, White, 315, 1000)
	Endif
	Sync()
	Sleep(1500)
EndFunction	

Function ExitHTP()
	If GetPointerReleased() = 1
		If GetSpriteHitTest( Button.iMenu, GetPointerX(), GetPointerY() ) = 1
			Click()
			tmp = QuitMenu()
		EndIf
	EndIf
	If GetRawKeyPressed(27) = 1
		Click()
		tmp = QuitMenu()
	Endif
EndFunction tmp		


// Project: British Squares Game
// Created: 2016-03-11
// Build: 1.0 3/22/16

// set window properties
SetWindowTitle( "British Squares" )
SetWindowSize( 630, 1120, 0 )
#Include "media.agc"
#Include "gamemodes.agc"
#Include "menus.agc"
#Include "howtoplay.agc"

// set display properties
SetVirtualResolution( 630, 1120 )
SetOrientationAllowed( 1, 0, 0, 0 )

Global Red
Global Blue
Global Green
Global Yellow
Global Purple
Global Orange
Global White

Red = MakeColor(236,0,0)
Blue = MakeColor(0,28,190)
Green = MakeColor(0,180,0)
Yellow = MakeColor(255,255,0)
Purple = MakeColor(205,0,205)
Orange = MakeColor(255,129,0)
White = MakeColor(238,238,238)

Type MediaType
	iMusic as Integer
	iTileSound as Integer
	iClick as Integer
	iSingleButton as Integer
	iMultiButton as Integer
	iHtpButton as Integer
	iSettingsButton as Integer
	iStartButton as Integer
	iMenuButton as Integer
	iUpButton as Integer
	iDownButton as Integer
	iEasyButton as Integer
	iNormalButton as Integer
	iHardButton as Integer
	iMenuTick as Integer
	iMiniBlock as Integer
	iTile as Integer
	iColorChoice as Integer
	iDifficultyChoice as Integer
	iHtp1 as Integer
	iHtp2 as Integer
	iHtp3 as Integer
	iHtp4 as Integer
	iSettingsOverlay as Integer
	iSingleOverlay as Integer
	iMultiOverlay as Integer
	iBackground as Integer
	iLogo as Integer
	iGameboard as Integer
	iTurnIndicator as Integer
	iFont as Integer
	iNumFont as Integer
	iOverlay as Integer
	iClearBoard as Integer
	iQuitOverlay as Integer
	iYesButton as Integer
	iNoButton as Integer
	iFanfare as integer
	iFanfare2 as Integer
	iEndRound as integer
	iNoScore as integer
	iRemoveAds as Integer
EndType

Type ButtonType
	iSinglePlayer as Integer
	iMultiplayer as Integer
	iHtp as Integer
	iSettings as Integer
	iMenu as Integer
	iStart as Integer
	iEasyButton as Integer
	iNormalButton as Integer
	iHardButton as Integer
	iTurnIndicator as Integer
	iSfxUp as Integer
	iSfxDown as Integer
	iMusicUp as Integer
	iMusicDown as Integer
	iRemoveAds as Integer
	iVibrate as Integer
EndType

Type TileType
	iFlag as Integer
	iTile as Integer
	iScore as Integer
	iHardTile as Integer
	iColor as Integer
	sName as String
EndType

Type FlagType
	iSFXLevel as integer
	iMusicLevel as Integer
	iRound as Integer
	iDifficulty as Integer
	iTurn as Integer
	iCenterSquare as Integer
	iReview as Integer
	iVibrate as Integer
EndType

Global Button as ButtonType
Global Media as MediaType
Global Dim GameBoard[24] as TileType
Global Flag as FlagType
Global Dim Player[1] as TileType
Global Dim Color[11] as TileType
Global p1score
Global p2score
Global GameOver
Global NextRoundFlag
global roundmessage
Global Dim available_spots[24]
Global quithtp as integer
Global GameCount as Integer = 0

HTP = 0
If GetFileExists( "settings" ) = 0 
	CreateSettingsFile()
	HTP = 1
ElseIf GetFileExists( "settings" ) = 1
	ReadSettingsFile()
	HTP = 0
Endif

//keys removed for public sharing
IF Left(GetDeviceBaseName(), 3) = "ios"
	//ios iap info	
	SetAdMobDetails("") // Interstitial Ads
	SetAdMobDetails("") //Banner Ads
Elseif Left(GetDeviceBaseName(), 3) = "and"
	InAppPurchaseSetKeys("", "")
	SetAdMobDetails("") //Interstitial Ads
	SetAdMobDetails("") //Banner Ads
EndIf


InAppPurchaseSetTitle ("British Square") // Name for alert dialogs etc.
If Left(GetDeviceBaseName(), 3) = "and" then InAppPurchaseAddProductID ("remove_ads", 0)
If Left(GetDeviceBaseName(), 3) = "ios" then InAppPurchaseAddProductID ("remove.ads", 0)
InAppPurchaseSetup()
InAppPurchaseRestore()

LoadMedia()
SetSoundSystemVolume(Flag.iSFXLevel)
Sleep(900)
CreateMainMenu()

//Set up Adverts 
if GetInAppPurchaseAvailable (0) = 0
		CreateAdvert(0, 1, 2, 0)
		SetAdvertLocation(1, 2, 315)
ElseIf GetInAppPurchaseAvailable(0) = 1
		DeleteAdvert()
Endif


	Player[0].sName = "Player 1"
	Player[1].sName = "Player 2"
	Player[0].iFlag = 0
	Player[1].iFlag = 1
	Player[0].iColor = Red
	Player[1].iColor = Blue
	Flag.iDifficulty = 1

do
	MainMenu:
	If GetPointerReleased() = 1 and cycle = 1
		If GetSpriteHitTest( Button.iSinglePlayer, GetPointerX(), GetPointerY() ) = 1 
			Click()
			IF HTP = 1 then HowtoPlay()
			HTP = 0
			DeleteSprite(Button.iRemoveAds)
			SingleMenu()
		ElseIf GetSpriteHitTest( Button.iMultiplayer, GetPointerX(), GetPointerY() ) = 1
			Click()
			IF HTP = 1 then HowtoPlay()
			HTP = 0
			DeleteSprite(Button.iRemoveAds)
			MultiMenu()
		ElseIf GetSpriteHitTest( Button.iHtp, GetPointerX(), GetPointerY() ) = 1
			Click()
			DeleteSprite(Button.iRemoveAds)
			HowToPlay()
			SetAdvertVisible(1)
		ElseIf GetSpriteHitTest( Button.iSettings, GetPointerX(), GetPointerY() ) = 1
			Click()
			DeleteSprite(Button.iRemoveAds)
			SettingsMenu()
		ElseIf GetSpriteHitTest( Button.iRemoveAds, GetPointerX(), GetPointerY() ) = 1
			Click()
			RemoveAds()
		EndIf
		cycle = 0
	EndIf	
	BackEnd(cycle)
	cycle = 1	
    Sync()
Loop
End

Function BackEnd(cycle)
	If GetRawKeyPressed(27) = 1 and cycle = 1
		End
	Endif
EndFunction

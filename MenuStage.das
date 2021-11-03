require daslib/media
require daslib/math
require Stage
require SpriteUtils
require TextUtils
require SoundManager
require Animations

enum private MenuLayers
    Players
    Options
    Credits

enum private PlayersMenuItems
    Practice
    OnePlayer
    TwoPlayers
    ThreePlayers
    Options

enum private OptionsMenuItems
    Difficulty
    Music
    Sound
    Credits

var playerCount: int = 0
var difficulty:  int = 0

class MenuStage : Stage
    logo:  Image <- create_image( "Images/logo.png" )

    key_w: Image <- create_image( "Images/Keys/letter_w.png" )
    key_a: Image <- create_image( "Images/Keys/letter_a.png" )
    key_s: Image <- create_image( "Images/Keys/letter_s.png" )
    key_d: Image <- create_image( "Images/Keys/letter_d.png" )
    key_v: Image <- create_image( "Images/Keys/letter_v.png" )
    key_b: Image <- create_image( "Images/Keys/letter_b.png" )

    key_left:    Image <- create_image( "Images/Keys/left_key.png" )
    key_right:   Image <- create_image( "Images/Keys/right_key.png" )
    key_up:      Image <- create_image( "Images/Keys/up_key.png" )
    key_down:    Image <- create_image( "Images/Keys/down_key.png" )
    key_shift:   Image <- create_image( "Images/Keys/shift_key.png" )
    key_control: Image <- create_image( "Images/Keys/ctrl_key.png" )

    gamepad_dpad: Image <- create_image( "Images/Keys/gamepad_dpad.png" )
    gamepad_a:    Image <- create_image( "Images/Keys/gamepad_a.png" )
    gamepad_b:    Image <- create_image( "Images/Keys/gamepad_b.png" )

    layer: MenuLayers = MenuLayers Players

    selection: int = int(PlayersMenuItems OnePlayer)
    menuTime: float = 0.0

    blockNavigation: bool = true

    nct: int = 0

    demoTimer: float = 0.0

    def MenuStage()
        logo |> make_image_color_transparent( logo |> get_pixel( 0, 0 ) )
        StartMusic()

    def override StageId()
        return Stages Menu

    def override TearDown()
        return

    def override Tick( timeElapsed: float )
        menuTime += timeElapsed * 5.0
        nct++

        let up     = get_key( VK_W ) || get_key( VK_UP   ) || get_axis( AXIS_POV_Y ) < -0.5
        let down   = get_key( VK_S ) || get_key( VK_DOWN ) || get_axis( AXIS_POV_Y ) >  0.5
        let esc    = get_key( VK_ESCAPE )
        let select = get_key( VK_SPACE ) || get_key( VK_RETURN ) || get_key( GP_A )

        if layer != MenuLayers Credits && !blockNavigation
            let menuItemCount = layer == MenuLayers Players ? 5 : 4
            if up && selection != 0
                --selection
                PlayMenuFx1()
            elif down && selection != menuItemCount - 1
                ++selection
                PlayMenuFx1()
            elif esc
                if layer == MenuLayers Players
                    schedule_quit_game()
                elif layer == MenuLayers Options
                    layer     = MenuLayers Players
                    selection = int( PlayersMenuItems Options )
                    PlayMenuFx2()
            elif select
                if layer == MenuLayers Players
                    if selection == int(PlayersMenuItems Options)
                        layer     = MenuLayers Options
                        selection = 0
                        PlaySfx( 2 )
                    else
                        playerCount = selection
                        PlaySfx( 2 )
                        return Stages Gameplay
                elif layer == MenuLayers Options
                    if selection == int(OptionsMenuItems Difficulty)
                        difficulty = ++difficulty % 3
                        PlaySfx( 2 )
                    elif selection == int(OptionsMenuItems Music)
                        musicEnabled = !musicEnabled
                        ApplySoundSettings()
                        PlaySfx( 2 )
                    elif selection == int(OptionsMenuItems Sound)
                        sfxEnabled = !sfxEnabled
                        ApplySoundSettings()
                        PlaySfx( 2 )
                    elif selection == int(OptionsMenuItems Credits)
                        layer = MenuLayers Credits
                        PlaySfx( 2 )
        elif layer == MenuLayers Credits && !blockNavigation
            if esc
                layer     = MenuLayers Options
                selection = int( OptionsMenuItems Credits )
                PlayMenuFx2()

        blockNavigation = up || down || esc || select
        if blockNavigation
            demoTimer = 0.0
        else
            demoTimer += timeElapsed
            if demoTimer > 20.0
                playerCount = -1
                return Stages Gameplay
        
        return Stages Menu

    def private DrawInput( player, x, y: int )
        let colors = [[uint[] 0xFFCCCCCC; 0xFFEE4466; 0xFF4444EE]]

        FillRect( float(x), float(y), 20.0, 10.0, colors[ player ])
        DrawBitmapText( x+2, y+2, 1.0, 0xFF000000, "P{player+1}"  )

    def override Draw()
        let prow    = 315
        let pcol1   = 85
        let pcol2   = 308
        let pcol3   = 557
        let spacing = 20

        let logoWidth  = float(logo.width)  * 2.0 * renderScale.x
        let logoHeight = float(logo.height) * 2.0 * renderScale.y
        logo |> draw_image( float(displayResolution.x) / 2.0 - logoWidth / 2.0, ( float(prow) * renderScale.y ) / 2.0 - logoHeight / 2.0, 0xFFFFFFFF, float2( logoWidth, logoHeight ) )

        if layer == MenuLayers Players
            var row: int = 35
            DrawPractice( row, selection == int(PlayersMenuItems Practice) )
            row += spacing
            DrawOnePlayer( row, selection == int(PlayersMenuItems OnePlayer) )
            row += spacing
            DrawTwoPlayers( row, selection == int(PlayersMenuItems TwoPlayers) )
            row += spacing
            DrawThreePlayers( row, selection == int(PlayersMenuItems ThreePlayers) )
            row += spacing
            DrawOptions( row, selection == int(PlayersMenuItems Options) )

            if selection != int(PlayersMenuItems Options)
                if selection == 0 || selection == 1
                    self->DrawInput( 0, pcol1, prow )
                    self->DrawInput( 0, pcol2, prow )
                    self->DrawInput( 0, pcol3, prow )
                elif selection == 2
                    self->DrawInput( 0, pcol1, prow )
                    self->DrawInput( 1, pcol2, prow )
                    self->DrawInput( 0, pcol3, prow )
                elif selection == 3
                    self->DrawInput( 0, pcol1, prow )
                    self->DrawInput( 1, pcol2, prow )
                    self->DrawInput( 2, pcol3, prow )

                let keyRow1 = 700 * displayResolution.y / 1000
                let keyRow2 = 755 * displayResolution.y / 1000
                let keyRow3 = 810 * displayResolution.y / 1000
                let keyRow4 = 865 * displayResolution.y / 1000

                let keyCol11 = 80  * displayResolution.x / 1000
                let keyCol12 = 121 * displayResolution.x / 1000
                let keyCol13 = 162 * displayResolution.x / 1000
                let keyCol14 = 203 * displayResolution.x / 1000
                let keyCol15 = 244 * displayResolution.x / 1000

                let keyCol21 = 430 * displayResolution.x / 1000
                let keyCol22 = 471 * displayResolution.x / 1000
                let keyCol23 = 512 * displayResolution.x / 1000
                let keyCol24 = 553 * displayResolution.x / 1000
                let keyCol25 = 585 * displayResolution.x / 1000

                let gpCol1 = 785 * displayResolution.x / 1000
                let gpCol2 = 855 * displayResolution.x / 1000
                let gpCol3 = 910 * displayResolution.x / 1000
                let gpRow1 = 700 * displayResolution.y / 1000
                let gpRow2 = 710 * displayResolution.y / 1000

                key_w |> draw_image( keyCol12, keyRow1, 0xFFFFFFFF )
                key_a |> draw_image( keyCol11, keyRow2, 0xFFFFFFFF )
                key_s |> draw_image( keyCol12, keyRow2, 0xFFFFFFFF )
                key_d |> draw_image( keyCol13, keyRow2, 0xFFFFFFFF )
                key_v |> draw_image( keyCol14, keyRow3, 0xFFFFFFFF )
                key_b |> draw_image( keyCol15, keyRow3, 0xFFFFFFFF )

                key_up      |> draw_image( keyCol22, keyRow1, 0xFFFFFFFF )
                key_left    |> draw_image( keyCol21, keyRow2, 0xFFFFFFFF )
                key_down    |> draw_image( keyCol22, keyRow2, 0xFFFFFFFF )
                key_right   |> draw_image( keyCol23, keyRow2, 0xFFFFFFFF )
                key_shift   |> draw_image( keyCol24, keyRow3, 0xFFFFFFFF )
                key_control |> draw_image( keyCol25, keyRow4, 0xFFFFFFFF )

                gamepad_dpad |> draw_image( gpCol1, gpRow1, 0xFFFFFFFF )
                gamepad_a    |> draw_image( gpCol2, gpRow2, 0xFFFFFFFF )
                gamepad_b    |> draw_image( gpCol3, gpRow2, 0xFFFFFFFF )
        
        elif layer == MenuLayers Options
            var row: int = 45
            DrawDifficulty( row, selection == int(OptionsMenuItems Difficulty), difficulty )
            row += spacing
            DrawMusic( row, selection == int(OptionsMenuItems Music), musicEnabled )
            row += spacing
            DrawSound( row, selection == int(OptionsMenuItems Sound), sfxEnabled )
            row += spacing
            DrawCredits( row, selection == int(OptionsMenuItems Credits) )

        elif layer == MenuLayers Credits
            let scale = 2.0
            var row: int = 45
            DrawBitmapTextMiddle( row, scale, 0xFFFFFFFF, "original version" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFFFFFF00, "game design" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFFFFFF00, "programming" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFFFFFF00, "graphics" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFFFFFF00, "animation" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFFFFFF00, "sound effects" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFF00FF00, "by" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFFFFFFFF, "archer maclean" )
            row += spacing * 3
            DrawBitmapTextMiddle( row, scale, 0xFF00FF00, "daScript version by" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFFFFFFFF, "laszlo perneky" )
            row += spacing * 2
            DrawBitmapTextMiddle( row, scale, 0xFF00FF00, "music by" )
            row += spacing
            DrawBitmapTextMiddle( row, scale, 0xFFFFFFFF, "kim rom" )

    def override SetNextCommand( characterIx: int; command: Commands )
        return

    def override GetCharacterFacing( characterIx: int )
        return 0

    def override GetCharacterPosition( characterIx: int )
        return 0.0

    def override GetCharacterWalkProjectedPosition( characterIx: int )
        return 0.0

    def override GetCharacterAnimation( characterIx: int )
        return Animations Idle

    def override IsCharacterDown( characterIx: int )
        return false

    def override IsCharacterBending( characterIx: int )
        return false

    def override GetLevel()
        return 0

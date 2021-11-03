require daslib/media
require RandomUtils

var musicEnabled: bool = true
var sfxEnabled:   bool = true

var private theme:       PcmSound <- create_sound( "Sounds/theme.mp3" )
var private themeHandle: PlayingSoundHandle

var private menufx1: PcmSound <- create_sound( "Sounds/menufx1.wav" )
var private menufx2: PcmSound <- create_sound( "Sounds/menufx2.wav" )

var private sfx <- [[ PcmSound[] create_sound( "Sounds/sfx01.wav" );
                                 create_sound( "Sounds/sfx02.wav" );
                                 create_sound( "Sounds/sfx03.wav" );
                                 create_sound( "Sounds/sfx04.wav" );
                                 create_sound( "Sounds/sfx05.wav" );
                                 create_sound( "Sounds/sfx06.wav" );
                                 create_sound( "Sounds/sfx07.wav" );
                                 create_sound( "Sounds/sfx08.wav" );
                                 create_sound( "Sounds/sfx09.wav" );
                                 create_sound( "Sounds/sfx10.wav" );
                                 create_sound( "Sounds/sfx11.wav" );
                                 create_sound( "Sounds/sfx12.wav" );
                                 create_sound( "Sounds/sfx13.wav" );
                                 create_sound( "Sounds/sfx14.wav" );
                                 create_sound( "Sounds/sfx15.wav" );
                                 create_sound( "Sounds/sfx16.wav" );
                                 create_sound( "Sounds/sfx17.wav" );
                                 create_sound( "Sounds/sfx18.wav" ) ]]

def StartMusic()
    if musicEnabled && !is_playing( themeHandle )
        themeHandle = theme |> play_sound()

def StopMusic()
    if is_playing( themeHandle )
        themeHandle |> stop_sound()

def PlayMenuFx1()
    if sfxEnabled
        menufx1 |> play_sound()

def PlayMenuFx2()
    if sfxEnabled
        menufx2 |> play_sound()

def PlaySfx( index: int )
    if sfxEnabled && index > 0
        sfx[ index - 1 ] |> play_sound()

def PlaySfxHit()
    let indices = [[auto 1; 2; 4; 5; 7; 18]]
    PlaySfx( indices[ Random( 0, length( indices ) - 1 ) ] )

def ApplySoundSettings()
    if musicEnabled
        StartMusic()
    else
        StopMusic()

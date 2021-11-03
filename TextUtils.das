require daslib/media
require SpriteUtils

let private fontSheet: Image <- CreateImageAndMakeTransparent( "Images/fonts.png" )

let private charWidth   = 8.0
let private charHeight  = 6.0
let private letterStart = float2( 8.0, 9.0 )
let private numberStart = float2( 128.0, 1.0 )

def private DrawMiddle( y: int; area: Area )
    let imageScale = renderScale * 2.0
    let sx         = float(displayResolution.x) * 0.5  - float(area.width) * imageScale.x * 0.5
    let sy         = float( y ) * renderScale.y * 2.0
    fontSheet |> draw_image_region( sx, sy, float4( area.left, area.top, area.width, area.height ), 0xFFFFFFFF, float2( area.width, area.height ) * imageScale )

def DrawPractice( y: int; selected: bool )
    DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 211, width = 128, height = 11 ]] )

def DrawOnePlayer( y: int; selected: bool )
    DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 35, width = 128, height = 11 ]] )

def DrawTwoPlayers( y: int; selected: bool )
    DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 51, width = 128, height = 11 ]] )

def DrawThreePlayers( y: int; selected: bool )
    DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 227, width = 128, height = 11 ]] )

def DrawOptions( y: int; selected: bool )
    DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 67, width = 128, height = 11 ]] )

def DrawDifficulty( y: int; selected: bool; difficulty: int )
    if difficulty == 0
        DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 83, width = 128, height = 11 ]] )
    elif difficulty == 1
        DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 99, width = 128, height = 11 ]] )
    elif difficulty == 2
        DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 115, width = 128, height = 11 ]] )

def DrawMusic( y: int; selected: bool; enabled: bool )
    if enabled
        DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 147, width = 128, height = 11 ]] )
    else
        DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 131, width = 128, height = 11 ]] )

def DrawSound( y: int; selected: bool; enabled: bool )
    if enabled
        DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 179, width = 128, height = 11 ]] )
    else
        DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 163, width = 128, height = 11 ]] )

def DrawCredits( y: int; selected: bool )
    DrawMiddle( y, [[ Area left = selected ? 128 : 0, top = 195, width = 128, height = 11 ]] )

def DrawBitmapText( x, y: int; scale: float; color: uint; text: string )
    var cx = float(x) * renderScale.x
    var cy = float(y) * renderScale.y

    for c in to_upper( text )
        if is_number( c )
            let lc = c - '0'
            fontSheet |> draw_image_region( cx, cy, float4( numberStart.x + charWidth * float(lc), numberStart.y, charWidth, charHeight ), color, float2( charWidth * renderScale.x * scale, charHeight * renderScale.y * scale ) )
        elif is_alpha( c )
            let lc = c - 'A'
            fontSheet |> draw_image_region( cx, cy, float4( letterStart.x + charWidth * float(lc), letterStart.y, charWidth, charHeight ), color, float2( charWidth * renderScale.x * scale, charHeight * renderScale.y * scale ) )
        cx += charWidth * renderScale.x * scale

def MeasureText( scale: float; text: string )
    return roundi( float( length( text ) ) * charWidth * scale )

def DrawBitmapTextMiddle( y: int; scale: float; color: uint; text: string )
    let tw = MeasureText( scale, text )
    DrawBitmapText( baseResolution.x / 2 - tw / 2, y, scale, color, text )

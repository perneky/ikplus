require daslib/media

let baseResolution    = int2(640, 480)
let displayResolution = int2(1280, 960)
let renderScale       = float2(displayResolution) / float2(baseResolution)

struct Area
    left, top, width, height : int

def CreateImageAndMakeTransparent( path: string )
    var image <- create_image( path )
    image |> make_image_color_transparent( image |> get_pixel( 0, 0 ) )
    return <- image

def private MakeOneSprite( source: Image const&; area: Area; recolor: table< uint; uint > )
    var sprite <- create_image( area.width, area.height )

    for x in range( area.left, area.left + area.width )
        for y in range( area.top, area.top + area.height )
            var pixel:     uint        = source |> get_pixel( x, y )
            var recolored: uint const? = find( recolor, pixel )
            sprite |> set_pixel( x - area.left, y - area.top, recolored != null ? deref( recolored ) : pixel )

    sprite |> make_image_color_transparent( source |> get_pixel( 0, 0 ) )

    return <- sprite

def MakeSprite( source: Image const&; area: Area )
    var sprites: tuple< Image; Image; Image >

    var recolor0: table< uint; uint >
    var recolor1: table< uint; uint >
    var recolor2: table< uint; uint >

    recolor0[ 0xFFDA0000 ] = 0xFFEEEEEE
    recolor1[ 0xFFDA0000 ] = 0xFFEE66EE
    recolor1[ 0xFFDADADA ] = 0xFFCC0000
    recolor1[ 0xFF919191 ] = 0xFF660000
    recolor2[ 0xFFDA0000 ] = 0xFFCCCC00
    recolor2[ 0xFFDADADA ] = 0xFF0000FF
    recolor2[ 0xFF919191 ] = 0xFF000066

    sprites._0 <- MakeOneSprite( source, area, recolor0 )
    sprites._1 <- MakeOneSprite( source, area, recolor1 )
    sprites._2 <- MakeOneSprite( source, area, recolor2 )

    return <- sprites

def DrawImage( image: Image const&; left, top, width, height: float; color: uint )
    let sleft   = left   * renderScale.x
    let stop    = top    * renderScale.y
    let swidth  = width  * renderScale.x
    let sheight = height * renderScale.y
    image |> draw_triangle_strip( [{auto float2(sleft, stop); float2(sleft + swidth, stop); float2(sleft, stop + sheight); float2(sleft + swidth, stop + sheight) }],
                                  [{auto float2(0, 0); float2(image.width, 0); float2(0, image.height); float2(image.width, image.height) }],
                                  color )

def DrawImage( image: Image const&; left, top: float; flipped: bool = false )
    DrawImage( image, left + ( flipped ? float(image.width) : 0.0 ), top, float(image.width) * ( flipped ? -1.0 : 1.0 ), float(image.height), 0xffffffff )

def DrawImage( image: Image const&; left, top: float; color: uint )
    DrawImage( image, left, top, float(image.width), float(image.height), color )

def DrawShadow( image: Image const&; left, top: float; flipped: bool = false )
    DrawImage( image, left + ( flipped ? float(image.width) : 0.0 ), top + float(image.height * 2), float(image.width) * ( flipped ? -1.0 : 1.0 ), float(-image.height), 0x30000000 )

def FillRect( left, top, width, height: float; color: uint )
    let sleft   = left   * renderScale.x
    let stop    = top    * renderScale.y
    let swidth  = width  * renderScale.x
    let sheight = height * renderScale.y
    fill_rect( sleft, stop, swidth, sheight, color )

def TextOut( x, y: int; text: string; color: uint )
    text_out( float(x) * renderScale.y, float(y) * renderScale.y, text, color)

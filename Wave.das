require math
require RandomUtils
require SpriteUtils

class Wave
    position:  float2 = float2(0,0)
    amplitude: float  = 0.0
    phase:     float  = 0.0
    speed:     float  = 0.0

    def Wave( pivot: int2; amp: int )
        position  = float2(pivot)
        amplitude = float(amp)

        let baseSpeed = PI / 2.0
        phase = Random() * 2.0 * PI
        speed = Random( baseSpeed - 0.2, baseSpeed + 0.2 )

    def Tick( timeElapsed: float )
        phase += timeElapsed * speed

    def Draw()
        let width = amplitude * ( sin( phase ) * 0.5 + 0.5 )
        FillRect( position.x, position.y, width, 2.0, 0xFF000008 )

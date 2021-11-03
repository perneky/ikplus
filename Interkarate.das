require daslib/media
require SpriteUtils
require Animations
require Stage
require StageManager
require InfluenceManager

[export]
def initialize
    set_window_title( "International Karate +" )
    set_resolution( displayResolution.x, displayResolution.y )
    set_antialiasing( 4 )

    SwitchStage( Stages Menu )

[export]
def act( dt: float )
    TickInfluences( dt, GetCurrentStage() )
    TickStage( dt * 1.0 )

[export]
def draw
    enable_alpha_blend()

    DrawStage()

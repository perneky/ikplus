require daslib/media

class ControllerSet
    def abstract isLeft () : bool
    def abstract isRight() : bool
    def abstract isUp   () : bool
    def abstract isDown () : bool
    def abstract isAlt  () : bool
    def abstract isBlock() : bool

class KB1Set : ControllerSet
    def override isLeft()
        return get_key( VK_A )
    def override isRight()
        return get_key( VK_D )
    def override isUp()
        return get_key( VK_W )
    def override isDown()
        return get_key( VK_S )
    def override isAlt()
        return get_key( VK_V )
    def override isBlock()
        return get_key( VK_B )

class KB2Set : ControllerSet
    def override isLeft()
        return get_key( VK_LEFT )
    def override isRight()
        return get_key( VK_RIGHT )
    def override isUp()
        return get_key( VK_UP )
    def override isDown()
        return get_key( VK_DOWN )
    def override isAlt()
        return get_key( VK_RSHIFT )
    def override isBlock()
        return get_key( VK_RCONTROL )

class GamepadSet : ControllerSet
    def override isLeft()
        return get_axis( AXIS_POV_X ) < -0.5
    def override isRight()
        return get_axis( AXIS_POV_X ) >  0.5
    def override isUp()
        return get_axis( AXIS_POV_Y ) < -0.5
    def override isDown()
        return get_axis( AXIS_POV_Y ) >  0.5
    def override isAlt()
        return get_key( GP_A )
    def override isBlock()
        return get_key( GP_B )

struct InputState
    leftDown, rightDown, upDown, downDown, altDown, blockDown: bool

def IsSame( thiz: InputState const&; other: InputState const& )
    with thiz
        return leftDown == other.leftDown && rightDown == other.rightDown && upDown == other.upDown && downDown == other.downDown && altDown == other.altDown && blockDown == other.blockDown

def Merge( var thiz: InputState&; other: InputState const& )
    with thiz
        if other.leftDown
            leftDown = true
        if other.rightDown
            rightDown = true
        if other.upDown
            upDown = true
        if other.downDown
            downDown = true
        if other.altDown
            altDown = true
        if other.blockDown
            blockDown = true

def GetCurrentInputState( var controller: ControllerSet?& )
    return [[ InputState leftDown  = controller->isLeft(), 
                         rightDown = controller->isRight(),
                         upDown    = controller->isUp(),
                         downDown  = controller->isDown(),
                         altDown   = controller->isAlt(),
                         blockDown = controller->isBlock() ]]

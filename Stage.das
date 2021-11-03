require Animations

enum Stages
    Gameplay
    Menu

enum Commands
    Nothing
    WalkForward
    WalkBackward
    Punch
    Jump
    Sweep
    TurnPunch
    LowKick
    LowPunch
    BackFlip
    FlyingKick
    ChestKick
    TurnSweep
    HeadButt
    HighKick
    DoubleFaceKick
    ReverseHighKick
    Block

class Stage
    def abstract StageId() : Stages

    def abstract TearDown() : void

    def abstract Tick( timeElapsed: float ) : Stages
    def abstract Draw() : void

    def abstract SetNextCommand( characterIx: int; command: Commands ) : void
    def abstract GetCharacterFacing( characterIx: int ) : int
    def abstract GetCharacterPosition( characterIx: int ) : float
    def abstract GetCharacterWalkProjectedPosition( characterIx: int ) : float
    def abstract GetCharacterAnimation( characterIx: int ) : Animations
    def abstract IsCharacterDown( characterIx: int ) : bool
    def abstract IsCharacterBending( characterIx: int ) : bool

    def abstract GetLevel() : int

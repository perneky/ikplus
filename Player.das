require daslib/media
require Influence
require Stage
require ControllerSets

class Player : Influence
    index: int

    inputTimer: float = 0.0
    lastInputState: InputState = [[ InputState ]]

    controllers: array< ControllerSet? >

    def Player( indexIn: int; set1, set2, set3: bool )
        index = indexIn

        if set1
            controllers |> push( new KB1Set() )
        if set2
            controllers |> push( new KB2Set() )
        if set3
            controllers |> push( new GamepadSet() )

    def override Reset()
        return

    def override Tick( timeElapsed: float; var stage: Stage? )
        var currentInputState = [[ InputState ]]
        for controller in controllers
            currentInputState |> Merge( GetCurrentInputState( controller ) )

        if currentInputState |> IsSame( lastInputState )
            inputTimer += timeElapsed
        else
            inputTimer = 0.0

        lastInputState = currentInputState

        let facing = stage->GetCharacterFacing( index )

        if inputTimer >= 0.025
            if currentInputState.blockDown
                stage->SetNextCommand( index, Commands Block )
            elif currentInputState.altDown
                if currentInputState.rightDown && currentInputState.upDown && facing > 0
                    stage->SetNextCommand( index, Commands HeadButt )
                elif currentInputState.leftDown && currentInputState.upDown && facing < 0
                    stage->SetNextCommand( index, Commands HeadButt )
                elif currentInputState.rightDown && currentInputState.downDown && facing > 0
                    stage->SetNextCommand( index, Commands HighKick )
                elif currentInputState.leftDown && currentInputState.downDown && facing < 0
                    stage->SetNextCommand( index, Commands HighKick )
                elif currentInputState.leftDown && currentInputState.upDown && facing > 0
                    stage->SetNextCommand( index, Commands DoubleFaceKick )
                elif currentInputState.rightDown && currentInputState.upDown && facing < 0
                    stage->SetNextCommand( index, Commands DoubleFaceKick )
                elif currentInputState.leftDown && currentInputState.downDown && facing > 0
                    stage->SetNextCommand( index, Commands ReverseHighKick )
                elif currentInputState.rightDown && currentInputState.downDown && facing < 0
                    stage->SetNextCommand( index, Commands ReverseHighKick )
                elif currentInputState.leftDown && facing > 0
                    stage->SetNextCommand( index, Commands BackFlip )
                elif currentInputState.rightDown && facing < 0
                    stage->SetNextCommand( index, Commands BackFlip )
                elif currentInputState.rightDown && facing > 0
                    stage->SetNextCommand( index, Commands ChestKick )
                elif currentInputState.leftDown && facing < 0
                    stage->SetNextCommand( index, Commands ChestKick )
                elif currentInputState.upDown
                    stage->SetNextCommand( index, Commands FlyingKick )
                elif currentInputState.downDown
                    stage->SetNextCommand( index, Commands TurnSweep )
            else
                if currentInputState.rightDown && currentInputState.upDown && facing > 0
                    stage->SetNextCommand( index, Commands Punch )
                elif currentInputState.rightDown && currentInputState.upDown && facing < 0
                    stage->SetNextCommand( index, Commands TurnPunch )
                elif currentInputState.leftDown && currentInputState.upDown && facing < 0
                    stage->SetNextCommand( index, Commands Punch )
                elif currentInputState.leftDown && currentInputState.upDown && facing > 0
                    stage->SetNextCommand( index, Commands TurnPunch )
                elif currentInputState.rightDown && currentInputState.downDown && facing > 0
                    stage->SetNextCommand( index, Commands LowKick )
                elif currentInputState.leftDown && currentInputState.downDown && facing < 0
                    stage->SetNextCommand( index, Commands LowKick )
                elif currentInputState.leftDown && currentInputState.downDown && facing > 0
                    stage->SetNextCommand( index, Commands LowPunch )
                elif currentInputState.rightDown && currentInputState.downDown && facing < 0
                    stage->SetNextCommand( index, Commands LowPunch )
                elif currentInputState.leftDown && facing < 0
                    stage->SetNextCommand( index, Commands WalkForward )
                elif currentInputState.leftDown && facing > 0
                    stage->SetNextCommand( index, Commands WalkBackward )
                elif currentInputState.rightDown && facing > 0
                    stage->SetNextCommand( index, Commands WalkForward )
                elif currentInputState.rightDown && facing < 0
                    stage->SetNextCommand( index, Commands WalkBackward )
                elif currentInputState.upDown
                    stage->SetNextCommand( index, Commands Jump )
                elif currentInputState.downDown
                    stage->SetNextCommand( index, Commands Sweep )
                else
                    stage->SetNextCommand( index, Commands Nothing )

require Stage
require GameplayStage
require MenuStage
require InfluenceManager

var private stage: Stage?

def private CreateGameplayStage : Stage?
    var newStage <- new GameplayStage()
    InitInfluences( playerCount )
    return <- newStage

def private CreateMenuStage : Stage?
    return new MenuStage()

let private stageFactory = [[auto @@CreateGameplayStage;  @@CreateMenuStage ]]

def SwitchStage( newStage: Stages )
    if stage != null
        stage->TearDown()

    stage = invoke( stageFactory[ int(newStage) ] )

def TickStage( timeElapsed: float )
    let newStage = stage->Tick( timeElapsed )
    if newStage != stage->StageId()
        SwitchStage( newStage )

def DrawStage()
    stage->Draw()

def GetCurrentStage() : Stage?
    return stage
require Influence
require Player
require Monkey
require Stage
require RandomUtils

var private influences: array< Influence? >

def InitInfluences( players: int )
    Randomize()
    clear( influences )
    if players == -1
        push( influences, new Monkey( 0, players ) )
        push( influences, new Monkey( 1, players ) )
        push( influences, new Monkey( 2, players ) )
    elif players == 0
        push( influences, new Player( 0, true, true, true ) )
    elif players == 1
        push( influences, new Player( 0, true, true, true ) )
        push( influences, new Monkey( 1, players ) )
        push( influences, new Monkey( 2, players ) )
    elif players == 2
        push( influences, new Player( 0, true,  false, true  ) )
        push( influences, new Player( 1, false, true,  false ) )
        push( influences, new Monkey( 2, players ) )
    elif players == 3
        push( influences, new Player( 0, true,  false, false ) )
        push( influences, new Player( 1, false, true,  false ) )
        push( influences, new Player( 2, false, false, true  ) )

def TickInfluences( timeElapsed: float; var stage: Stage? )
    for influence in influences
        influence->Tick( timeElapsed, stage )

def ResetInfluences()
    Randomize()
    for influence in influences
        influence->Reset()

def IsInPractice()
    return length( influences ) == 1
require Stage

class Influence
    def abstract Tick( timeElapsed: float; var stage: Stage? ) : void
    def abstract Reset() : void

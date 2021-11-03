require daslib/math
require Influence
require Stage
require RandomUtils
require Animations
require MenuStage

enum private Intents
    Idle
    HighPunch
    LowPunch
    LowKick
    MidKick
    HighKick
    Sweep
    Headbutt
    JumpKick
    JumpDoubleKick

    ReversePunch
    ReverseHighKick
    ReverseSweep

enum private AttackType
    None
    Low
    High

let private intentRanges = [[ float2[] float2(   0.0,   0.0 )    // Idle
                                     ; float2(  40.0,  50.0 )    // HighPunch
                                     ; float2(  70.0,  80.0 )    // LowPunch
                                     ; float2(  75.0,  85.0 )    // LowKick
                                     ; float2(  60.0,  70.0 )    // MidKick
                                     ; float2(  55.0,  65.0 )    // HighKick
                                     ; float2( 120.0, 130.0 )    // Sweep
                                     ; float2(  40.0,  50.0 )    // Headbutt
                                     ; float2(  90.0, 100.0 )    // JumpKick
                                     ; float2(  60.0,  70.0 )    // JumpDoubleKick
                                     ; float2(  40.0,  50.0 )    // ReversePunch
                                     ; float2( 130.0, 140.0 )    // ReverseHighKick
                                     ; float2( 120.0, 130.0 ) ]] // ReverseSweep

let private actions = [[ Intents[] Intents HighPunch
                                 ; Intents LowPunch
                                 ; Intents LowKick
                                 ; Intents MidKick
                                 ; Intents HighKick
                                 ; Intents Sweep
                                 ; Intents Headbutt
                                 ; Intents JumpKick
                                 ; Intents JumpDoubleKick
                                 ; Intents ReversePunch
                                 ; Intents ReverseSweep
                                 ; Intents ReverseHighKick ]]

def private TraceMonkey( ix: int; message: string )
    if ix == 2
        print( message + "\n" )

class Monkey : Influence
    index: int

    intent:       Intents
    intentTarget: int
    intentTimer:  float

    actTimer: float

    blockTimer: float
    noblockTimer: float

    playerCount: int

    def Monkey( indexIn, playerCountIn: int )
        index       = indexIn
        playerCount = playerCountIn
        self->Reset();

    def GetDifficulty( var stage: Stage? )
        return stage->GetLevel() + ( playerCount < 0 ? 1 : difficulty ) * 8

    def private PlanNextIntent( var stage: Stage? )
        if intent == Intents Idle
            intentTimer  = 0.0
            if playerCount == 2
                intentTarget = Random( 0, 1 )
            elif playerCount == -1
                if index == 2
                    intentTarget = Random( 0, 1 )
                elif index == 1
                    intentTarget = Random( 0, 1 ) < 1 ? 0 : 2
                elif index == 0
                    intentTarget = Random( 1, 2 )
            else
                if index == 2
                    intentTarget = Random( 0, 2 ) < 2 ? 0 : 1 // Attack human players with higher probability
                elif index == 1
                    intentTarget = Random( 0, 2 ) < 2 ? 0 : 2 // Attack human players with higher probability

            let facing    = stage->GetCharacterFacing( index )
            let posSelf   = stage->GetCharacterWalkProjectedPosition( index )
            let posOther  = stage->GetCharacterPosition( intentTarget )
            let direction = roundi( sign( posOther - posSelf ) )
            let behind    = direction != facing

            intent = actions[ Random( 0, 8 ) ]

            if behind
                let distance = abs( posOther - posSelf )
                if distance < intentRanges[ int(Intents ReverseHighKick) ].x
                    if Random() < 0.5
                        intent = actions[ Random( 9, 10 ) ]
                elif distance < intentRanges[ int(Intents ReverseHighKick) ].x * 2.0
                    if Random() < 0.5
                        intent = Intents ReverseHighKick
        else
            intent       = Intents Idle
            intentTarget = 0

            let level   = float(self->GetDifficulty( stage ))
            let minWait = max( 1.0 - level * 0.10, 0.01 )
            let maxWait = max( 3.0 - level * 0.15, 0.01 )
            intentTimer = Random( minWait, maxWait )

    def private Act( var stage: Stage? )
        if intent == Intents HighPunch
            stage->SetNextCommand( index, Commands Punch )
        elif intent == Intents LowPunch
            stage->SetNextCommand( index, Commands LowPunch )
        elif intent == Intents LowKick
            stage->SetNextCommand( index, Commands LowKick )
        elif intent == Intents MidKick
            stage->SetNextCommand( index, Commands ChestKick )
        elif intent == Intents HighKick
            stage->SetNextCommand( index, Commands HighKick )
        elif intent == Intents Sweep
            stage->SetNextCommand( index, Commands Sweep )
        elif intent == Intents Headbutt
            stage->SetNextCommand( index, Commands HeadButt )
        elif intent == Intents JumpKick
            stage->SetNextCommand( index, Commands FlyingKick )
        elif intent == Intents JumpDoubleKick
            stage->SetNextCommand( index, Commands DoubleFaceKick )
        elif intent == Intents ReversePunch
            stage->SetNextCommand( index, Commands TurnPunch )
        elif intent == Intents ReverseSweep
            stage->SetNextCommand( index, Commands TurnSweep )
        elif intent == Intents ReverseHighKick
            stage->SetNextCommand( index, Commands ReverseHighKick )
        
        self->PlanNextIntent( stage );

    def private GetAttackType( anim: Animations )
        if anim == Animations SweepStart || anim == Animations TurnSweepStart || anim == Animations LowKickStart
            return AttackType Low
        if anim == Animations PunchStart || anim == Animations TurnPunchStart || anim == Animations LowPunchStart || anim == Animations FlyingKick || anim == Animations ChestKickStart || anim == Animations HeadButtStart || anim == Animations HighKickStart || anim == Animations DoubleFaceKick || anim == Animations ReverseHighKick
            return AttackType High

        return AttackType None

    def private GetAttackDistance( anim: Animations )
        if anim == Animations SweepStart
            return intentRanges[ int(Intents Sweep) ]
        if anim == Animations TurnSweepStart
            return intentRanges[ int(Intents ReverseSweep) ]
        if anim == Animations LowKickStart
            return intentRanges[ int(Intents LowKick) ]
        if anim == Animations PunchStart
            return intentRanges[ int(Intents HighPunch) ]
        if anim == Animations TurnPunchStart
            return intentRanges[ int(Intents ReversePunch) ]
        if anim == Animations LowPunchStart
            return intentRanges[ int(Intents LowPunch) ]
        if anim == Animations FlyingKick
            return intentRanges[ int(Intents JumpKick) ]
        if anim == Animations ChestKickStart
            return intentRanges[ int(Intents MidKick) ]
        if anim == Animations HeadButtStart
            return intentRanges[ int(Intents Headbutt) ]
        if anim == Animations HighKickStart
            return intentRanges[ int(Intents HighKick) ]
        if anim == Animations DoubleFaceKick
            return intentRanges[ int(Intents JumpDoubleKick) ]
        if anim == Animations ReverseHighKick
            return intentRanges[ int(Intents ReverseHighKick) ]

        return float2( 0, 0 )

    def private CheckBlocking( var stage: Stage? )
        if noblockTimer > 0.0
            return false

        let others = index == 1 ? [[auto 0; 2]] : [[auto 0; 1]]
        for other in others
            let facing          = stage->GetCharacterFacing( index )
            let facingOther     = stage->GetCharacterFacing( other )
            let posSelf         = stage->GetCharacterWalkProjectedPosition( index )
            let posOther        = stage->GetCharacterPosition( other )
            let signedDistance  = posOther - posSelf;
            let targetDirection = roundi( sign( signedDistance ) )
            let isFacingOther   = targetDirection == 0 || facing == targetDirection
            if !isFacingOther
                continue

            let animation  = stage->GetCharacterAnimation( other )
            let attackType = self->GetAttackType( animation )

            let dangerZone  = float2( posOther, posOther ) + self->GetAttackDistance( animation ) * float(facingOther)
            let dangerZoneC = float2( min( dangerZone.x, dangerZone.y ), max( dangerZone.x, dangerZone.y ) )
            let needEvasion = attackType != AttackType None && posSelf >= dangerZoneC.x && posSelf <= dangerZone.y

            if needEvasion
                if attackType == AttackType High
                    if Random() < min( float(self->GetDifficulty( stage )) * 0.03, 0.5 )
                        blockTimer = Random( 0.5, 1.5 )
                        stage->SetNextCommand( index, Commands Block )
                        return true
                    else
                        noblockTimer = 0.5
                elif attackType == AttackType Low
                    if Random() < min( float(self->GetDifficulty( stage )) * 0.03, 0.5 )
                        stage->SetNextCommand( index, Commands Jump )
                        return true
                    else
                        noblockTimer = 0.5

        return false

    def override Reset()
        let level   = float( difficulty * 8 )
        let minWait = max( 0.5 - level * 0.05, 0.01 )
        let maxWait = max( 2.0 - level * 0.05, 0.01 )

        intent       = Intents Idle
        intentTarget = 0
        intentTimer  = Random( minWait, maxWait )
        blockTimer   = 0.0
        noblockTimer = 0.0

    def override Tick( timeElapsed: float; var stage: Stage? )
        if noblockTimer > 0.0
            noblockTimer -= timeElapsed

        if blockTimer > 0.0
            blockTimer -= timeElapsed
            if blockTimer > 0.0
                stage->SetNextCommand( index, Commands Block )
                return

        if self->CheckBlocking( stage )
            return

        if intent == Intents Idle
            if !stage->IsCharacterBending( index )
                intentTimer -= timeElapsed
            if intentTimer <= 0.0
                self->PlanNextIntent( stage );
            else
                return

        if stage->IsCharacterDown( intentTarget )
            self->PlanNextIntent( stage );
            return

        if actTimer > 0.0
            actTimer -= timeElapsed
            if actTimer <= 0.0
                self->Act( stage )
            return

        let facing          = stage->GetCharacterFacing( index )
        let posSelf         = stage->GetCharacterWalkProjectedPosition( index )
        let posTarget       = stage->GetCharacterPosition( intentTarget )
        let signedDistance  = posTarget - posSelf;
        let targetDirection = roundi( sign( signedDistance ) )
        let isFacingTarget  = targetDirection == 0 || facing == targetDirection
        let minmax          = intentRanges[ int(intent) ]
        let needBackwards   = intent == Intents ReversePunch || intent == Intents ReverseHighKick || intent == Intents ReverseSweep

        if !isFacingTarget && !needBackwards
            stage->SetNextCommand( index, Commands TurnPunch )
        elif isFacingTarget && needBackwards
            stage->SetNextCommand( index, Commands TurnPunch )
        else
            let distance = abs( signedDistance )
            let inRange  = distance >= minmax.x && distance <= minmax.y

            if inRange
                if needBackwards
                    self->Act( stage )
                else
                    let level   = float(self->GetDifficulty( stage ))
                    let minWait = max( 0.5 - level * 0.05, 0.01 )
                    let maxWait = max( 1.5 - level * 0.05, 0.01 )
                    actTimer = Random( minWait, maxWait )
                    stage->SetNextCommand( index, Commands Nothing )
            else
                if ( !needBackwards )
                    stage->SetNextCommand( index, distance < minmax.x ? Commands WalkBackward : Commands WalkForward )
                else
                    stage->SetNextCommand( index, distance < minmax.x ? Commands WalkForward : Commands WalkBackward )

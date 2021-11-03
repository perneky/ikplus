require daslib/media
require daslib/math
require SpriteUtils
require Stage
require Character
require Animations
require Wave
require InfluenceManager
require RandomUtils
require TextUtils

def Isect( a, b: int3 )
    return length( float2( int2( a.x, a.y ) - int2( b.x, b.y ) ) ) < float( a.z + b.z )

class GameplayStage : Stage
    characters: array< Character? >
    waves: array< Wave? >
    worm: Character?

    background1 <- create_image( "Images/background1.png" )
    background2 <- create_image( "Images/background2.png" )
    scoredot    <- create_image( "Images/scoredot.png" )

    timeLeft: float = 30.0
    sunPhase: float = 0.0

    startLocations = [[ auto 100; 400; 550 ]]
    startFacings   = [[ auto 1; -1; -1 ]]

    isInEndGame:  bool  = false
    endGameTimer: float = 0.0

    level: int = 1

    def GameplayStage()
        background1 |> make_image_color_transparent( background1 |> get_pixel( 0, 0 ) )
        background2 |> make_image_color_transparent( background2 |> get_pixel( 0, 0 ) )

        push( characters, new Character( startLocations[ 0 ], startFacings[ 0 ] ) )
        push( characters, new Character( startLocations[ 1 ], startFacings[ 1 ] ) )
        push( characters, new Character( startLocations[ 2 ], startFacings[ 2 ] ) )

        push( waves, new Wave( int2( 187, 204 ), 10 ) )
        push( waves, new Wave( int2( 203, 206 ), 10 ) )
        push( waves, new Wave( int2( 187, 208 ), 10 ) )
        push( waves, new Wave( int2( 175, 210 ), 11 ) )
        push( waves, new Wave( int2( 153, 212 ), 11 ) )
        push( waves, new Wave( int2( 117, 214 ), 11 ) )
        push( waves, new Wave( int2( 109, 216 ), 12 ) )
        push( waves, new Wave( int2( 95,  218 ), 12 ) )
        push( waves, new Wave( int2( 75,  220 ), 13 ) )
        push( waves, new Wave( int2( 49,  222 ), 13 ) )
        push( waves, new Wave( int2( 33,  224 ), 14 ) )
        push( waves, new Wave( int2( 19,  226 ), 14 ) )

        push( waves, new Wave( int2( 143, 214 ),  2 ) )
        push( waves, new Wave( int2( 143, 216 ),  2 ) )
        push( waves, new Wave( int2( 143, 218 ),  2 ) )
        push( waves, new Wave( int2( 140, 214 ), -2 ) )
        push( waves, new Wave( int2( 140, 216 ), -2 ) )
        push( waves, new Wave( int2( 140, 218 ), -2 ) )

        push( waves, new Wave( int2( 444, 204 ), -10 ) )
        push( waves, new Wave( int2( 420, 206 ), -10 ) )
        push( waves, new Wave( int2( 436, 208 ), -10 ) )
        push( waves, new Wave( int2( 450, 210 ), -11 ) )
        push( waves, new Wave( int2( 470, 212 ), -11 ) )
        push( waves, new Wave( int2( 480, 214 ), -11 ) )
        push( waves, new Wave( int2( 504, 216 ), -12 ) )
        push( waves, new Wave( int2( 512, 218 ), -12 ) )
        push( waves, new Wave( int2( 530, 220 ), -13 ) )
        push( waves, new Wave( int2( 544, 222 ), -13 ) )
        push( waves, new Wave( int2( 570, 224 ), -14 ) )
        push( waves, new Wave( int2( 620, 224 ), -14 ) )
        push( waves, new Wave( int2( 591, 224 ),  14 ) )
        push( waves, new Wave( int2( 574, 226 ), -14 ) )
        push( waves, new Wave( int2( 581, 226 ),  14 ) )

        worm = new Character( 150, 1 );
        worm.needPositionClamping = false

    def override StageId()
        return Stages Gameplay

    def override TearDown() : void
        return

    def override Tick( timeElapsed: float )
        if get_key( VK_ESCAPE ) || get_key( GP_BACK ) || get_key( GP_START )
            return Stages Menu

        if !IsInPractice()
            if !isInEndGame && characters[ 0 ].currentAnimation != Animations Bend
                timeLeft = max( timeLeft - timeElapsed, 0.0 )
                if ( timeLeft == 0.0 )
                    let maxScore = max( characters[ 0 ]->GetHits(), max( characters[ 1 ]->GetHits(), characters[ 2 ]->GetHits() ) )
                    if maxScore > 0
                        if characters[ 0 ]->GetHits() == maxScore
                            characters[ 0 ]->AddScore( 1 )
                        if characters[ 1 ]->GetHits() == maxScore
                            characters[ 1 ]->AddScore( 1 )
                        if characters[ 2 ]->GetHits() == maxScore
                            characters[ 2 ]->AddScore( 1 )
                    isInEndGame = true

        if isInEndGame
            for character in characters
                character.nextAnimation = Animations Idle
                character->Tick( timeElapsed )

            endGameTimer += timeElapsed
            if endGameTimer > 5.0
                endGameTimer = 0.0
                self->ResetMatch()
                isInEndGame = false
                level++

            return Stages Gameplay

        worm->Tick( timeElapsed )
        if int(worm.position) > baseResolution.x
            worm.position = -10.0

        for character in characters
            character->Tick( timeElapsed )

        for wave in waves
            wave->Tick( timeElapsed )

        sunPhase += timeElapsed * 1.5
        while ( sunPhase >= PI * 2.0 )
            sunPhase -= PI * 2.0

        self->TryHit( 0, 1 )
        self->TryHit( 0, 2 )
        self->TryHit( 1, 0 )
        self->TryHit( 1, 2 )
        self->TryHit( 2, 0 )
        self->TryHit( 2, 1 )

        if !IsInPractice()
            for character in characters
                if character->GetHits() > 5
                    character->AddScore( 1 )
                    isInEndGame = true
                    break

        return Stages Gameplay

    def private ResetMatch()
        characters[ 0 ]->Reset( startLocations[ 0 ], startFacings[ 0 ] )
        characters[ 1 ]->Reset( startLocations[ 1 ], startFacings[ 1 ] )
        characters[ 2 ]->Reset( startLocations[ 2 ], startFacings[ 2 ] )
        ResetInfluences()
        timeLeft = 30.0

    def private TryHitWithArea( hitArea: int3; facing, b: int )
        if hitArea == int3(0, 0, 0)
            return 0

        let blocking = characters[ b ].currentAnimation == Animations Block && facing != characters[ b ].facing

        let headArea = characters[ b ]->GetHeadArea()
        if !blocking && headArea != int3(0, 0, 0) && Isect( hitArea, headArea )
            return characters[ b ]->Hit( false, facing != characters[ b ].facing )

        let bellyArea = characters[ b ]->GetBellyArea()
        if !blocking && bellyArea != int3(0, 0, 0) && Isect( hitArea, bellyArea )
            return characters[ b ]->Hit( true, facing != characters[ b ].facing )

        let chestArea = characters[ b ]->GetChestArea()
        if !blocking && chestArea != int3(0, 0, 0) && Isect( hitArea, chestArea )
            return characters[ b ]->Hit( false, facing != characters[ b ].facing )

        let feet1Area = characters[ b ]->GetFeet1Area()
        if feet1Area != int3(0, 0, 0) && Isect( hitArea, feet1Area )
            return characters[ b ]->Hit( false, facing != characters[ b ].facing )

        let feet2Area = characters[ b ]->GetFeet2Area()
        if feet2Area != int3(0, 0, 0) && Isect( hitArea, feet2Area )
            return characters[ b ]->Hit( false, facing != characters[ b ].facing )

        let leg1Area = characters[ b ]->GetLeg1Area()
        if leg1Area != int3(0, 0, 0) && Isect( hitArea, leg1Area )
            return characters[ b ]->Hit( false, facing != characters[ b ].facing )

        let leg2Area = characters[ b ]->GetLeg2Area()
        if leg2Area != int3(0, 0, 0) && Isect( hitArea, leg2Area )
            return characters[ b ]->Hit( false, facing != characters[ b ].facing )

        return 0

    def private TryHit( a, b: int )
        if !characters[ a ]->IsActive() || !characters[ b ]->IsActive()
            return 0

        var points = self->TryHitWithArea( characters[ a ]->GetHitArea1(), characters[ a ].facing, b ) + self->TryHitWithArea( characters[ a ]->GetHitArea2(), characters[ a ].facing, b )
        characters[ a ]->AddHits( points )

        return points

    def private DrawSunReflection()
        let rowHeight     = 2
        let sunStart      = 204
        let sunEnd        = 256
        let sunAmpMin     = 40.0
        let sunAmpStart   = 0.0
        let sunAmpEnd     = 70.0
        let sunInnerColor = 0xFFDEEE09
        let sunOuterColor = 0xFFC7548D

        var phaseInc = PI / 3.0
        var phase    = sunPhase
        var row      = sunStart
        while ( row < sunEnd )
            let rowT  = float(row - sunStart) / float(sunEnd - sunStart)
            let ampl  = lerp( sunAmpStart, sunAmpEnd, rowT )
            let width = abs( sin( phase ) ) * ampl + sunAmpMin

            FillRect( float(baseResolution.x) * 0.5 - width * 0.5, float(row), width, float(rowHeight), sunOuterColor )
            FillRect( float(baseResolution.x) * 0.5 - width * 0.25, float(row), width * 0.5, float(rowHeight), sunInnerColor )

            phase += phaseInc
            row   += rowHeight
            
            phaseInc += 0.1

    def private DrawScore( left, score: int; color: uint )
        for x in range( 0, 6 )
            DrawImage( scoredot, float(left + x * ( scoredot.width + 2 )), 60.0, x < score ? color : 0xFF666666 )

    def override Draw()
        DrawImage( background1, 0.0, 0.0 )
        for wave in waves
            wave->Draw()
        self->DrawSunReflection()
        DrawImage( background2, 0.0, 0.0 )

        worm->Draw( float(gameLine - 45), 0 )
        worm.currentAnimation = Animations Worm;
        worm.nextAnimation    = Animations Worm;

        if isInEndGame
            let bbl = DrawSensei( 150, gameLine - 30 )
            let bbs = 3.75
            if characters[ 0 ]->GetHits() > characters[ 1 ]->GetHits() && characters[ 0 ]->GetHits() > characters[ 2 ]->GetHits()
                DrawBitmapText( bbl.x + 32, bbl.y + 32, bbs, 0xFFFFFFFF, "WHITE WINS" )
            elif characters[ 1 ]->GetHits() > characters[ 0 ]->GetHits() && characters[ 1 ]->GetHits() > characters[ 2 ]->GetHits()
                DrawBitmapText( bbl.x + 60, bbl.y + 32, bbs, 0xFFCC0000, "RED WINS" )
            elif characters[ 2 ]->GetHits() > characters[ 0 ]->GetHits() && characters[ 2 ]->GetHits() > characters[ 1 ]->GetHits()
                DrawBitmapText( bbl.x + 48, bbl.y + 32, bbs, 0xFF0000FF, "BLUE WINS" )
            else
                DrawBitmapText( bbl.x + 28, bbl.y + 32, bbs, 0xFF00AA00, "ITS A DRAW" )

        var charIx: int = length( characters ) - 1
        while ( charIx >= 0 )
            characters[ charIx ]->Draw( float(gameLine), charIx )
            --charIx

        if !IsInPractice()
            self->DrawUI()

    def private DrawUI()
        let uiScale = 3.0

        let colors = [[ auto 0xFFCCCCCC; 0xFFEE4466; 0xFF4444EE ]]
        for charIx in range( 0, length( characters ) )
            let left  = ( scoredot.width + 2 ) + charIx * 7 * ( scoredot.width + 1 )
            let score = characters[ charIx ]->GetScore()
            self->DrawScore( left, characters[ charIx ]->GetHits(), colors[ charIx ] )
            DrawBitmapText( left - 3, 32, uiScale, colors[ charIx ], "won " + (score < 10 ? " " : "") + "{score}" )

        DrawBitmapText( 485, 32, uiScale, 0xFFAA00EE, "LV" )
        DrawBitmapText( 485, 60, uiScale, 0xFFAA00EE, ( level < 10 ? "0" : "" ) + "{level}")

        let timeDisplay = int( ceil( timeLeft ) )

        DrawBitmapText( 540, 32, uiScale, 0xFF4488EE, "TIME" )
        DrawBitmapText( 540, 60, uiScale, 0xFF4488EE, ( timeDisplay < 10 ? " 0" : " " ) + "{timeDisplay}")

    def override SetNextCommand( characterIx: int; command: Commands )
        var character: Character? = characters[ characterIx ]

        if ( character.currentAnimation == Animations SweepStart || character.currentAnimation == Animations TurnSweepStart || character.currentAnimation == Animations SweepKeep ) && command != Commands Sweep
            character.nextAnimation = Animations SweepEnd
        elif ( character.currentAnimation == Animations PunchStart || character.currentAnimation == Animations TurnPunchStart || character.currentAnimation == Animations PunchKeep ) && command != Commands Punch
            character.nextAnimation = Animations PunchEnd
        elif ( character.currentAnimation == Animations LowKickStart || character.currentAnimation == Animations LowKickKeep ) && command != Commands LowKick
            character.nextAnimation = Animations LowKickEnd
        elif ( character.currentAnimation == Animations HighKickStart || character.currentAnimation == Animations HighKickKeep || character.currentAnimation == Animations ReverseHighKick ) && command != Commands HighKick
            character.nextAnimation = Animations HighKickEnd
        elif ( character.currentAnimation == Animations ChestKickStart || character.currentAnimation == Animations ChestKickKeep ) && command != Commands ChestKick
            character.nextAnimation = Animations ChestKickEnd
        elif ( character.currentAnimation == Animations LowPunchStart || character.currentAnimation == Animations LowPunchKeep ) && command != Commands LowPunch
            character.nextAnimation = Animations LowPunchEnd
        elif ( character.currentAnimation == Animations HeadButtStart || character.currentAnimation == Animations HeadButtKeep ) && command != Commands HeadButt
            character.nextAnimation = Animations HeadButtEnd
        elif command == Commands Nothing
            character.nextAnimation = Animations Idle
        elif command == Commands WalkForward
            character.nextAnimation = Animations Walk
        elif command == Commands WalkBackward
            character.nextAnimation = Animations WalkBack
        elif command == Commands Jump
            character.nextAnimation = Animations Jump
        elif command == Commands Sweep
            if character.currentAnimation == Animations SweepStart || character.currentAnimation == Animations TurnSweepStart || character.currentAnimation == Animations SweepKeep
                character.nextAnimation = Animations SweepKeep
            else
                character.nextAnimation = Animations SweepStart
        elif command == Commands Punch
            if character.currentAnimation == Animations PunchStart || character.currentAnimation == Animations TurnPunchStart || character.currentAnimation == Animations PunchKeep
                character.nextAnimation = Animations PunchKeep
            else
                character.nextAnimation = Animations PunchStart
        elif command == Commands LowPunch
            if character.currentAnimation == Animations LowPunchStart || character.currentAnimation == Animations LowPunchKeep
                character.nextAnimation = Animations LowPunchKeep
            else
                character.nextAnimation = Animations LowPunchStart
        elif command == Commands LowKick
            if character.currentAnimation == Animations LowKickStart || character.currentAnimation == Animations LowKickKeep
                character.nextAnimation = Animations LowKickKeep
            else
                character.nextAnimation = Animations LowKickStart
        elif command == Commands HighKick
            if character.currentAnimation == Animations HighKickStart || character.currentAnimation == Animations ReverseHighKick || character.currentAnimation == Animations HighKickKeep
                character.nextAnimation = Animations HighKickKeep
            else
                character.nextAnimation = Animations HighKickStart
        elif command == Commands ChestKick
            if character.currentAnimation == Animations ChestKickStart || character.currentAnimation == Animations ChestKickKeep
                character.nextAnimation = Animations ChestKickKeep
            else
                character.nextAnimation = Animations ChestKickStart
        elif command == Commands TurnPunch
            character.nextAnimation = Animations TurnPunchStart
        elif command == Commands BackFlip
            character.nextAnimation = Animations BackFlip
        elif command == Commands FlyingKick
            character.nextAnimation = Animations FlyingKick
        elif command == Commands DoubleFaceKick
            character.nextAnimation = Animations DoubleFaceKick
        elif command == Commands TurnSweep
            if character.currentAnimation == Animations TurnSweepStart || character.currentAnimation == Animations SweepKeep
                character.nextAnimation = Animations SweepKeep
            else
                character.nextAnimation = Animations TurnSweepStart
        elif command == Commands HeadButt
            if character.currentAnimation == Animations HeadButtStart || character.currentAnimation == Animations HeadButtKeep
                character.nextAnimation = Animations HeadButtKeep
            else
                character.nextAnimation = Animations HeadButtStart
        elif command == Commands ReverseHighKick
            if character.currentAnimation == Animations ReverseHighKick || character.currentAnimation == Animations HighKickKeep
                character.nextAnimation = Animations HighKickKeep
            else
                character.nextAnimation = Animations ReverseHighKick
        elif command == Commands Block
            character.nextAnimation = Animations Block

    def override GetCharacterFacing( characterIx: int )
        return characters[ characterIx ].facing

    def override GetCharacterPosition( characterIx: int ) : float
        return characters[ characterIx ].position

    def override GetCharacterWalkProjectedPosition( characterIx: int )
        return characters[ characterIx ]->GetWalkProjectedPos()

    def override GetCharacterAnimation( characterIx: int )
        return characters[ characterIx ].currentAnimation

    def override GetLevel()
        return level

    def override IsCharacterDown( characterIx: int )
        let anim = characters[ characterIx ].currentAnimation
        return anim == Animations FallBack || anim == Animations FallButt || anim == Animations FallFace

    def override IsCharacterBending( characterIx: int )
        let anim = characters[ characterIx ].currentAnimation
        return anim == Animations Bend

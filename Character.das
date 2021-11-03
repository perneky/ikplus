require daslib/media
require math
require Animation
require Animations
require SpriteUtils
require SoundManager

let gameLine = 416

class Character
    currentAnimation: Animations = Animations Bend
    nextAnimation:    Animations = Animations Idle
    currentPose:      int        = 0
    timeSpentInPose:  float      = 0.0
    position:         float      = 0.0
    facing:           int        = 1

    hitTimer: float = 0.0

    needPositionClamping: bool = true

    hits:  int = 0
    score: int = 0

    def Character( startingPos: int; initialFacing: int )
        self->Reset( startingPos, initialFacing )

    def private CalcSpriteLeft()
        var pose:   Pose  const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
        var sprite: Image const& = pose.sprites._0
        if needPositionClamping
            return clamp( facing > 0 ? position - float(pose.pivot) : position - float(sprite.width - pose.pivot), 0.0, float(baseResolution.x - sprite.width))
        else
            return facing > 0 ? position - float(pose.pivot) : position - float(sprite.width - pose.pivot)

    def Draw( base: float; charIx: int )
        var pose:   Pose  const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
        var sprite: Image const& = charIx == 0 ? pose.sprites._0 : ( charIx == 1 ? pose.sprites._1 : pose.sprites._2 )
        let dp = self->CalcSpriteLeft()

        DrawImage( sprite, dp, base - float(sprite.height), facing < 0 )
        DrawShadow( sprite, dp, base - float(sprite.height), facing < 0 )

    def GetWalkProjectedPos()
        if currentAnimation == Animations Walk || currentAnimation == Animations WalkBack
            var pose:     Pose const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
            var nextPose: Pose const& = animationInstances[ int(currentAnimation) ].poses[ ( currentPose + 1 ) % length( animationInstances[ int(currentAnimation) ].poses ) ]
            return position + float(facing) * ( timeSpentInPose / pose.duration ) * nextPose.teleport
        else
            return position

    def Tick( timeElapsed: float )
        if hitTimer > 0.0
            hitTimer -= timeElapsed

        if currentAnimation != nextAnimation && animationInstances[ int(currentAnimation) ].interruptable
            if currentAnimation == Animations Walk || currentAnimation == Animations WalkBack
                position = self->GetWalkProjectedPos()

            self->PlayNextAnimation( false )
            timeSpentInPose = 0.0
            PlaySfx( animationInstances[ int(currentAnimation) ].poses[ currentPose ].sfx )

        self->AdvancePose( timeElapsed )

    def IsActive()
        return currentAnimation != Animations FallBack

    def TransformArea( loc: int3; pose: Pose const& )
        let dp = roundi( self->CalcSpriteLeft() )

        if facing > 0
            return int3( dp + loc.x, loc.y + gameLine - pose.sprites._0.height, loc.z )
        else
            return int3( dp + pose.sprites._0.width - loc.x, loc.y + gameLine - pose.sprites._0.height, loc.z )

    def GetHitArea1() : int3
        if hitTimer > 0.0
            return int3(0, 0, 0)

        var pose: Pose const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
        if pose.hitLocation1 == int3(0, 0, 0)
            return pose.hitLocation1
        
        return self->TransformArea( pose.hitLocation1, pose )

    def GetHitArea2() : int3
        if hitTimer > 0.0
            return int3(0, 0, 0)

        var pose: Pose const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
        if pose.hitLocation2 == int3(0, 0, 0)
            return pose.hitLocation2
        
        return self->TransformArea( pose.hitLocation2, pose )

    def GetHeadArea() : int3
        var pose: Pose const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
        if pose.headLocation == int3(0, 0, 0)
            return pose.headLocation
        
        return self->TransformArea( pose.headLocation, pose )

    def GetBellyArea() : int3
        var pose: Pose const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
        if pose.bellyLocation == int3(0, 0, 0)
            return pose.bellyLocation
        
        return self->TransformArea( pose.bellyLocation, pose )

    def GetChestArea() : int3
        let headArea  = self->GetHeadArea()
        let bellyArea = self->GetBellyArea()
        if headArea == int3(0, 0, 0) || bellyArea == int3(0, 0, 0)
            return int3(0, 0, 0)
        
        return (headArea + bellyArea) / 2

    def GetFeet1Area() : int3
        var pose: Pose const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
        if pose.feet1Location == int3(0, 0, 0)
            return pose.feet1Location
        
        return self->TransformArea( pose.feet1Location, pose )

    def GetFeet2Area() : int3
        var pose: Pose const& = animationInstances[ int(currentAnimation) ].poses[ currentPose ]
        if pose.feet2Location == int3(0, 0, 0)
            return pose.feet2Location
        
        return self->TransformArea( pose.feet2Location, pose )

    def GetLeg1Area() : int3
        let bellyArea = self->GetBellyArea()
        let feetArea  = self->GetFeet1Area()
        if feetArea == int3(0, 0, 0) || bellyArea == int3(0, 0, 0)
            return int3(0, 0, 0)
        
        return (feetArea + bellyArea) / 2

    def GetLeg2Area() : int3
        let bellyArea = self->GetBellyArea()
        let feetArea  = self->GetFeet2Area()
        if feetArea == int3(0, 0, 0) || bellyArea == int3(0, 0, 0)
            return int3(0, 0, 0)
        
        return (feetArea + bellyArea) / 2

    def Hit( toTheBalls, isFrontal: bool)
        if toTheBalls && isFrontal
            currentAnimation = Animations FallButt
        elif isFrontal
            currentAnimation = Animations FallBack
        else
            currentAnimation = Animations FallFace
        nextAnimation    = Animations Idle
        currentPose      = 0
        timeSpentInPose  = 0.0

        PlaySfxHit()

        return isFrontal ? 2 : 1

    def private ClampPosition()
        if needPositionClamping
            let edge = 50.0
            position = clamp( position, edge, float(baseResolution.x) - edge )

    def private Teleport()
        position += animationInstances[ int(currentAnimation) ].poses[ currentPose ].teleport * float(facing)

    def private AdvancePose( timeElapsed: float )
        timeSpentInPose += timeElapsed
        while ( timeSpentInPose >= animationInstances[ int(currentAnimation) ].poses[ currentPose ].duration || animationInstances[ int(currentAnimation) ].poses[ currentPose ].duration == 0.0 )
            timeSpentInPose -= animationInstances[ int(currentAnimation) ].poses[ currentPose ].duration

            if animationInstances[ int(currentAnimation) ].poses[ currentPose ].turnaround
                facing *= -1

            if currentPose < length( animationInstances[ int(currentAnimation) ].poses ) - 1
                currentPose++
                self->Teleport()
            else
                self->PlayNextAnimation( true )

            PlaySfx( animationInstances[ int(currentAnimation) ].poses[ currentPose ].sfx )

            self->ClampPosition()

    def private PlayNextAnimation( animationEnded: bool )
        if currentAnimation != Animations Walk || currentAnimation != Animations WalkBack || nextAnimation != Animations Walk || nextAnimation != Animations WalkBack || animationEnded
            currentPose = 0

        currentAnimation = nextAnimation
        nextAnimation    = Animations Idle

        self->Teleport()

    def GetScore()
        return score

    def AddScore( amount: int )
        score += amount

    def GetHits()
        return hits
    
    def AddHits( amount: int )
        hits += amount
        if amount > 0
            hitTimer = 0.2

    def Reset( startLocation, startFacing: int )
        currentAnimation = Animations Bend
        nextAnimation    = Animations Idle
        currentPose      = 0
        timeSpentInPose  = 0.0
        position         = float(startLocation)
        facing           = startFacing
        hits             = 0

require daslib/media

struct Pose
    sprites:       tuple< Image; Image; Image >
    pivot:         int
    duration:      float
    speed:         float
    teleport:      float
    turnaround:    bool
    hitLocation1:  int3
    hitLocation2:  int3
    headLocation:  int3
    bellyLocation: int3
    feet1Location: int3
    feet2Location: int3
    sfx:           int

struct Animation
    poses:         array< Pose >
    interruptable: bool

require daslib/media
require Animation
require SpriteUtils

enum Animations
    Bend
    Idle
    Walk
    WalkBack
    Jump
    SweepStart
    SweepKeep
    SweepEnd
    TurnSweepStart
    PunchStart
    PunchKeep
    PunchEnd
    TurnPunchStart
    LowKickStart
    LowKickKeep
    LowKickEnd
    LowPunchStart
    LowPunchKeep
    LowPunchEnd
    FallBack
    FallFace
    FallButt
    BackFlip
    FlyingKick
    ChestKickStart
    ChestKickKeep
    ChestKickEnd
    HeadButtStart
    HeadButtKeep
    HeadButtEnd
    HighKickStart
    HighKickKeep
    HighKickEnd
    DoubleFaceKick
    ReverseHighKick
    Block
    /// Environment
    Worm

let private spritesheet <- CreateImageAndMakeTransparent( "Images/character_sheet.png" )
let private propsheet   <- CreateImageAndMakeTransparent( "Images/sprites.png" )

let animationInstances <- [[ Animation[]
                             // Bend
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 1.0, pivot = 18, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 852, width = 34, height = 108 ]] );
                                                           duration = 1.0, pivot = 12, sprites <- MakeSprite( spritesheet, [[ Area left = 1302, top = 852, width = 58, height = 108 ]] );
                                                           duration = 1.0, pivot = 18, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 852, width = 34, height = 108 ]] ) }] ]]
                             ;// Idle
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 1.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0, top = 88, width = 98, height = 104]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// Walk
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.1, teleport = 20.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 144,  top = 88,   width = 92, height = 104 ]] ), headLocation = int3( 37, 11, 9 ), bellyLocation = int3( 40, 56, 10 ), feet1Location = int3( 63, 98, 5 ), feet2Location = int3( 10, 98, 5 );
                                                           duration = 0.1, teleport = 26.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 288,  top = 88,   width = 86, height = 104 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 39, 96, 5 ), feet2Location = int3( 19, 96, 5 );
                                                           duration = 0.1, teleport = 16.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 432,  top = 88,   width = 86, height = 104 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 33, 56, 10 ), feet1Location = int3( 25, 98, 5 ), feet2Location = int3( 47, 98, 5 );
                                                           duration = 0.1, teleport = 14.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 1296, top = 1048, width = 86, height = 104 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 33, 56, 10 ), feet1Location = int3( 41, 96, 5 ), feet2Location = int3( 36, 98, 5 );
                                                           duration = 0.1, teleport = 20.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 288,  top = 280,  width = 84, height = 104 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.1, teleport = 8.0,  pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 88,   width = 98, height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// WalkBack
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.1, teleport = -8.0,  pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 288,  top = 280,  width = 84, height = 104 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.1, teleport = -20.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 1296, top = 1048, width = 86, height = 104 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 33, 56, 10 ), feet1Location = int3( 41, 96, 5 ), feet2Location = int3( 36, 98, 5 );
                                                           duration = 0.1, teleport = -14.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 432,  top = 88,   width = 86, height = 104 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 33, 56, 10 ), feet1Location = int3( 25, 98, 5 ), feet2Location = int3( 47, 98, 5 );
                                                           duration = 0.1, teleport = -16.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 288,  top = 88,   width = 86, height = 104 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 39, 96, 5 ), feet2Location = int3( 19, 96, 5 );
                                                           duration = 0.1, teleport = -26.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 144,  top = 88,   width = 92, height = 104 ]] ), headLocation = int3( 37, 11, 9 ), bellyLocation = int3( 40, 56, 10 ), feet1Location = int3( 63, 98, 5 ), feet2Location = int3( 10, 98, 5 );
                                                           duration = 0.1, teleport = -20.0, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 88,   width = 98, height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// Jump
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 42, teleport = 0.0, sprites <- MakeSprite( spritesheet, [[ Area left = 720, top = 92,  width = 72, height = 100 ]] ), headLocation = int3( 39, 11, 9 ), bellyLocation = int3( 27, 48, 10 ), feet1Location = int3( 50, 94, 5 ), feet2Location = int3( 21, 94, 5 );
                                                           duration = 0.1, pivot = 30, teleport = 0.0, sprites <- MakeSprite( spritesheet, [[ Area left = 290, top = 454, width = 78, height = 122 ]] ), headLocation = int3( 27, 11, 9 ), bellyLocation = int3( 34, 45, 10 );
                                                           duration = 0.1, pivot = 30, teleport = 2.0, sprites <- MakeSprite( spritesheet, [[ Area left = 434, top = 452, width = 82, height = 124 ]] ), headLocation = int3( 27, 11, 9 ), bellyLocation = int3( 34, 45, 10 );
                                                           duration = 0.1, pivot = 30, teleport = 2.0, sprites <- MakeSprite( spritesheet, [[ Area left = 434, top = 452, width = 82, height = 124 ]] ), headLocation = int3( 27, 11, 9 ), bellyLocation = int3( 34, 45, 10 );
                                                           duration = 0.1, pivot = 42, teleport = 2.0, sprites <- MakeSprite( spritesheet, [[ Area left = 720, top = 92,  width = 72, height = 100 ]] ), headLocation = int3( 39, 11, 9 ), bellyLocation = int3( 27, 48, 10 ), feet1Location = int3( 50, 94, 5 ), feet2Location = int3( 21, 94, 5 );
                                                           duration = 0.1, pivot = 46, teleport = 0.0, sprites <- MakeSprite( spritesheet, [[ Area left = 0,   top = 88,  width = 98, height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// SweepStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 36, sprites <- MakeSprite( spritesheet, [[ Area left = 432, top = 694, width = 82,  height = 74 ]] ), headLocation = int3( 33, 11, 9 ), bellyLocation = int3( 36, 44, 10 ), feet1Location = int3( 72,  63, 5 ), feet2Location = int3( 29, 68, 5 ), sfx = 9;
                                                           duration = 0.2, pivot = 44, sprites <- MakeSprite( spritesheet, [[ Area left = 288, top = 710, width = 144, height = 58 ]] ), headLocation = int3( 43, 13, 9 ), bellyLocation = int3( 48, 38, 10 ), feet2Location = int3( 40, 52, 5 ), hitLocation1 = int3( 134, 50, 5 ) }] ]]
                             ;// SweepKeep
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 1.0, pivot = 44, sprites <- MakeSprite( spritesheet, [[ Area left = 288, top = 710, width = 144, height = 58 ]] ), headLocation = int3( 43, 13, 9 ), bellyLocation = int3( 48, 38, 10 ), feet2Location = int3( 40, 52, 5 ) }] ]]
                             ;// SweepEnd
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 36, sprites <- MakeSprite( spritesheet, [[ Area left = 432, top = 694, width = 82,  height = 74 ]] ), headLocation = int3( 33, 11, 9 ), bellyLocation = int3( 36, 44, 10 ), feet1Location = int3( 72, 63, 5 ), feet2Location = int3( 29, 68, 5 ) }] ]]
                             ;// TurnSweepStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 1048, width = 94,  height = 104 ]] ), headLocation = int3( 42, 11, 9 ), bellyLocation = int3( 43, 56, 10 ), feet1Location = int3( 80, 98, 5 ), feet2Location = int3( 10, 98, 5 ), turnaround = true;
                                                           duration = 0.1, pivot = 36, sprites <- MakeSprite( spritesheet, [[ Area left = 432,  top = 694,  width = 82,  height = 74  ]] ), headLocation = int3( 33, 11, 9 ), bellyLocation = int3( 36, 44, 10 ), feet1Location = int3( 72, 63, 5 ), feet2Location = int3( 29, 68, 5 ), sfx = 9;
                                                           duration = 0.2, pivot = 44, sprites <- MakeSprite( spritesheet, [[ Area left = 288,  top = 710,  width = 144, height = 58  ]] ), headLocation = int3( 43, 13, 9 ), bellyLocation = int3( 48, 38, 10 ), feet2Location = int3( 40, 52, 5 ), hitLocation1 = int3( 134, 50, 5 ) }] ]]
                             ;// PunchStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 38, sprites <- MakeSprite( spritesheet, [[ Area left = 720, top = 280, width = 72, height = 104 ]] ), headLocation = int3( 35, 11, 9 ), bellyLocation = int3( 36, 44, 10 ), feet1Location = int3( 57, 98, 5 ), feet2Location = int3( 8, 98, 5 );
                                                           duration = 0.2, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 4,   top = 472, width = 92, height = 104 ]] ), headLocation = int3( 37, 11, 9 ), bellyLocation = int3( 33, 54, 10 ), feet1Location = int3( 57, 98, 5 ), feet2Location = int3( 9, 98, 5 ), hitLocation1 = int3( 87, 22, 5 ), sfx = 2 }] ]]
                             ;// PunchKeep
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.2, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 4, top = 472, width = 92, height = 104 ]] ), headLocation = int3( 37, 11, 9 ), bellyLocation = int3( 33, 54, 10 ), feet1Location = int3( 57, 98, 5 ), feet2Location = int3( 9, 98, 5 ) }] ]]
                             ;// PunchEnd
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 38, sprites <- MakeSprite( spritesheet, [[ Area left = 720, top = 280, width = 72, height = 104 ]] ), headLocation = int3( 35, 11, 9 ), bellyLocation = int3( 36, 44, 10 ), feet1Location = int3( 57, 98, 5 ), feet2Location = int3( 8, 98, 5 ) }] ]]
                             ;// TurnPunchStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 1048, width = 94, height = 104 ]] ), headLocation = int3( 42, 11, 9 ), bellyLocation = int3( 43, 56, 10 ), feet1Location = int3( 80, 98, 5 ), feet2Location = int3( 10, 98, 5 ), turnaround = true;
                                                           duration = 0.1, pivot = 38, sprites <- MakeSprite( spritesheet, [[ Area left = 720,  top = 280,  width = 72, height = 104 ]] ), headLocation = int3( 35, 11, 9 ), bellyLocation = int3( 36, 44, 10 ), feet1Location = int3( 57, 98, 5 ), feet2Location = int3( 8, 98, 5 ), sfx = 8;
                                                           duration = 0.2, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 4,    top = 472,  width = 92, height = 104 ]] ), headLocation = int3( 37, 11, 9 ), bellyLocation = int3( 33, 54, 10 ), feet1Location = int3( 57, 98, 5 ), feet2Location = int3( 9, 98, 5 ), hitLocation1 = int3( 87, 22, 5 ) }] ]]
                             ;// LowKickStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 432, top = 282, width = 74,  height = 102 ]] ), headLocation = int3( 21, 11, 9 ), bellyLocation = int3( 34, 48, 10 ), feet2Location = int3( 36, 96, 4 ), sfx = 7;
                                                           duration = 0.2, pivot = 38, sprites <- MakeSprite( spritesheet, [[ Area left = 144, top = 476, width = 112, height = 100 ]] ), headLocation = int3( 17, 11, 9 ), bellyLocation = int3( 35, 48, 10 ), feet2Location = int3( 33, 94, 5 ), hitLocation1 = int3( 106, 74, 4 ) }] ]]
                             ;// LowKickKeep
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.2, pivot = 38, sprites <- MakeSprite( spritesheet, [[ Area left = 144, top = 476, width = 112, height = 100 ]] ), headLocation = int3( 17, 11, 9 ), bellyLocation = int3( 35, 48, 10 ), feet2Location = int3( 33, 94, 5 ) }] ]]
                             ;// LowKickEnd
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 432, top = 282, width = 74, height = 102 ]] ), headLocation = int3( 21, 11, 9 ), bellyLocation = int3( 34, 48, 10 ), feet2Location = int3( 36, 96, 4 ) }] ]]
                             ;// LowPunchStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 50, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 302, width = 64,  height = 82 ]] ), headLocation = int3( 21, 11, 9 ), bellyLocation = int3( 22, 50, 10 ), feet1Location = int3( 51, 76, 4 ), feet2Location = int3( 9, 96, 3 ), sfx = 5;
                                                           duration = 0.2, pivot = 44, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 304, width = 124, height = 80 ]] ), headLocation = int3( 69, 11, 9 ), bellyLocation = int3( 58, 48, 10 ), feet1Location = int3( 75, 74, 5 ), feet2Location = int3( 41, 74, 5 ), hitLocation1 = int3( 118, 33, 5 ) }] ]]
                             ;// LowPunchKeep
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.2, pivot = 44, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 304, width = 124, height = 80 ]] ), headLocation = int3( 69, 11, 9 ), bellyLocation = int3( 58, 48, 10 ), feet1Location = int3( 75, 74, 5 ), feet2Location = int3( 41, 74, 5 ) }] ]]
                             ;// LowPunchEnd
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 50, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 302, width = 64, height = 82 ]] ), headLocation = int3( 21, 11, 9 ), bellyLocation = int3( 22, 50, 10 ), feet1Location = int3( 51, 76, 4 ), feet2Location = int3( 9, 96, 3 ) }] ]]
                             ;// FallBack
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 46, teleport = 0.0,   sprites <- MakeSprite( spritesheet, [[ Area left = 0,   top = 842, width = 86,  height = 118 ]] );
                                                           duration = 0.1, pivot = 46, teleport = -16.0, sprites <- MakeSprite( spritesheet, [[ Area left = 144, top = 876, width = 138, height = 84  ]] );
                                                           duration = 0.1, pivot = 46, teleport = -16.0, sprites <- MakeSprite( spritesheet, [[ Area left = 288, top = 908, width = 138, height = 52  ]] );
                                                           duration = 1.0, pivot = 46, teleport = -16.0, sprites <- MakeSprite( spritesheet, [[ Area left = 432, top = 936, width = 140, height = 24  ]] );
                                                           // Lying on the ground
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 1104, width = 124, height = 48 ]] );
                                                           duration = 0.2, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 864,  top = 1088, width = 120, height = 64 ]] );
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 722,  top = 1078, width = 90,  height = 74 ]] );
                                                           duration = 0.2, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 576,  top = 1080, width = 104, height = 72 ]] );
                                                           duration = 0.2, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 576,  top = 686,  width = 96,  height = 82 ]] );
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 88,   width = 98,  height = 104]] ) }] ]]
                             ;// FallFace
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 46, teleport = 0.0,  sprites <- MakeSprite( spritesheet, [[ Area left = 576,  top = 858, width = 96,  height = 102 ]] );
                                                           duration = 0.1, pivot = 46, teleport = 20.0, sprites <- MakeSprite( spritesheet, [[ Area left = 748,  top = 872, width = 96,  height = 88  ]] );
                                                           duration = 0.1, pivot = 46, teleport = 0.0,  sprites <- MakeSprite( spritesheet, [[ Area left = 864,  top = 896, width = 138, height = 64  ]] );
                                                           duration = 1.0, pivot = 46, teleport = 0.0,  sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 938, width = 142, height = 22  ]] );
                                                           // Lying on the ground
                                                           duration = 0.2, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 432,  top = 1124, width = 136, height = 28  ]] );
                                                           duration = 0.2, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 288,  top = 1086, width = 136, height = 66  ]] );
                                                           duration = 0.5, pivot = 30, sprites <- MakeSprite( spritesheet, [[ Area left = 576,  top = 686,  width = 96,  height = 82  ]] );
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 88,   width = 98,  height = 104 ]] ) }] ]]
                             ;// FallButt
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 46, teleport = 0.0,   sprites <- MakeSprite( spritesheet, [[ Area left = 864,  top = 664, width = 80,  height = 104 ]] );
                                                           duration = 0.1, pivot = 46, teleport = -30.0, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 670, width = 76,  height = 98  ]] );
                                                           duration = 0.1, pivot = 46, teleport = -20.0, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 688, width = 110, height = 80  ]] );
                                                           duration = 1.0, pivot = 46, teleport = -10.0, sprites <- MakeSprite( spritesheet, [[ Area left = 1296, top = 696, width = 120, height = 72  ]] );
                                                           // Lying on the ground
                                                           duration = 0.2, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 576,  top = 1080, width = 104, height = 72  ]] );
                                                           duration = 0.2, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 722,  top = 1078, width = 90,  height = 74  ]] );
                                                           duration = 0.5, pivot = 30, sprites <- MakeSprite( spritesheet, [[ Area left = 576,  top = 686,  width = 96,  height = 82  ]] );
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 88,   width = 98,  height = 104 ]] ) }] ]]
                             ;// BackFlip
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 52,  sprites <- MakeSprite( spritesheet, [[ Area left = 1296, top = 466, width = 56,  height = 110 ]] ), headLocation = int3( 13,  19,  9 ), bellyLocation = int3( 16, 60, 10 ), feet1Location = int3( 29, 102, 5 );
                                                           duration = 0.1, pivot = 100, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 652, width = 108, height = 116 ]] ), headLocation = int3( 30,  31,  9 ), bellyLocation = int3( 63, 52, 10 ), feet1Location = int3( 79, 107, 5 );
                                                           duration = 0.1, pivot = 132, sprites <- MakeSprite( spritesheet, [[ Area left = 144,  top = 672, width = 116, height = 96  ]] ), headLocation = int3( 34,  32,  9 ), bellyLocation = int3( 68, 17, 10 );
                                                           duration = 0.1, pivot = 136, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 92,  width = 100, height = 100 ]] ), headLocation = int3( 23,  58,  9 ), bellyLocation = int3( 32, 21, 10 ), feet1Location = int3( 6,  84,  5 );
                                                           duration = 0.1, pivot = 145, sprites <- MakeSprite( spritesheet, [[ Area left = 1304, top = 92,  width = 88,  height = 100 ]] ), headLocation = int3( 30,  69,  9 ), bellyLocation = int3( 15, 38, 10 ), feet1Location = int3( 17, 94,  5 );
                                                           duration = 0.1, pivot = 165, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 244, width = 64,  height = 140 ]] ), headLocation = int3( 54,  104, 9 ), bellyLocation = int3( 29, 76, 10 ), feet1Location = int3( 35, 134, 5 );
                                                           duration = 0.1, pivot = 222, sprites <- MakeSprite( spritesheet, [[ Area left = 144,  top = 294, width = 116, height = 90  ]] ), headLocation = int3( 107, 48,  9 ), bellyLocation = int3( 76, 16, 10 ), feet1Location = int3( 93, 84,  5 );
                                                           duration = 0.1, pivot = 212, sprites <- MakeSprite( spritesheet, [[ Area left = 576,  top = 102, width = 98,  height = 90  ]] ), headLocation = int3( 86,  29,  9 ), bellyLocation = int3( 36, 12, 10 ), feet1Location = int3( 9,  72,  5 );
                                                           duration = 0.1, pivot = 228, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 486, width = 72,  height = 90  ]] ), headLocation = int3( 49,  10,  9 ), bellyLocation = int3( 16, 32, 10 ), feet1Location = int3( 19, 84,  5 );
                                                           duration = 0.1, pivot = 261, sprites <- MakeSprite( spritesheet, [[ Area left = 720,  top = 92,  width = 72,  height = 100 ]] ), headLocation = int3( 39,  11,  9 ), bellyLocation = int3( 28, 48, 10 ), feet1Location = int3( 50, 94,  5 ), feet2Location = int3( 21, 94, 5 );
                                                           
                                                           duration = 0.1, pivot = 46,  teleport = -238.0, sprites <- MakeSprite( spritesheet, [[ Area left = 0, top = 88, width = 98, height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// FlyingKick
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 42, teleport = 0.0,  sprites <- MakeSprite( spritesheet, [[ Area left = 720,  top = 92,   width = 72,  height = 100 ]] ), headLocation = int3( 39, 11, 9 ), bellyLocation = int3( 28, 48, 10 ), feet1Location = int3( 50, 94,  5 ), feet2Location = int3( 21, 94, 5 ), sfx = 8;
                                                           duration = 0.1, pivot = 30, teleport = 0.0,  sprites <- MakeSprite( spritesheet, [[ Area left = 290,  top = 454,  width = 78,  height = 122 ]] ), headLocation = int3( 27, 11, 9 ), bellyLocation = int3( 33, 46, 10 );
                                                           duration = 0.1, pivot = 30, teleport = 13.0, sprites <- MakeSprite( spritesheet, [[ Area left = 1296, top = 1196, width = 116, height = 148 ]] ), headLocation = int3( 29, 11, 9 ), bellyLocation = int3( 33, 44, 10 ), hitLocation1 = int3( 108, 55, 3 );
                                                           duration = 0.1, pivot = 30, teleport = 15.0, sprites <- MakeSprite( spritesheet, [[ Area left = 1296, top = 1196, width = 116, height = 148 ]] ), headLocation = int3( 29, 11, 9 ), bellyLocation = int3( 33, 44, 10 ), hitLocation1 = int3( 108, 55, 3 );
                                                           duration = 0.1, pivot = 30, teleport = 15.0, sprites <- MakeSprite( spritesheet, [[ Area left = 434,  top = 452,  width = 82,  height = 124 ]] ), headLocation = int3( 27, 11, 9 ), bellyLocation = int3( 30, 48, 10 );
                                                           duration = 0.1, pivot = 42, teleport = 13.0, sprites <- MakeSprite( spritesheet, [[ Area left = 720,  top = 92,   width = 72,  height = 100 ]] ), headLocation = int3( 39, 11, 9 ), bellyLocation = int3( 29, 48, 10 ), feet1Location = int3( 50, 93, 5 ), feet2Location = int3( 21, 93, 5 );
                                                           duration = 0.1, pivot = 46, teleport = 0.0,  sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 88,   width = 98,  height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// ChestKickStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 432,  top = 282, width = 74,  height = 102 ]] ), headLocation = int3( 21, 11, 9 ), bellyLocation = int3( 34, 48, 10 ), feet2Location = int3( 36, 96, 4 ), sfx = 8;
                                                           duration = 0.1, pivot = 63, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 94,  width = 106, height = 98  ]] ), headLocation = int3( 18, 11, 9 ), bellyLocation = int3( 52, 37, 10 ), feet2Location = int3( 62, 90, 5 );
                                                           duration = 0.2, pivot = 68, sprites <- MakeSprite( spritesheet, [[ Area left = 578,  top = 288, width = 136, height = 96  ]] ), headLocation = int3( 15, 11, 9 ), bellyLocation = int3( 55, 35, 10 ), feet2Location = int3( 69, 90, 5 ), hitLocation1 = int3( 129, 26, 5 ) }] ]]
                             ;// ChestKickKeep
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.2, pivot = 68, sprites <- MakeSprite( spritesheet, [[ Area left = 578,  top = 288, width = 136, height = 96  ]] ), headLocation = int3( 15, 11, 9 ), bellyLocation = int3( 55, 35, 10 ), feet2Location = int3( 69, 90, 5 ) }] ]]
                             ;// ChestKickEnd
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 68, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 94,  width = 106, height = 98  ]] ), headLocation = int3( 18, 11, 9 ), bellyLocation = int3( 52, 37, 10 ), feet2Location = int3( 62, 90, 5 );
                                                           duration = 0.1, pivot = 63, sprites <- MakeSprite( spritesheet, [[ Area left = 432,  top = 282, width = 74,  height = 102 ]] ), headLocation = int3( 21, 11, 9 ), bellyLocation = int3( 34, 48, 10 ), feet2Location = int3( 36, 96, 4 );
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 88,  width = 98,  height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// HeadButtStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 720,  top = 474, width = 96, height = 102 ]] ), headLocation = int3( 25, 11, 9 ), bellyLocation = int3( 43, 56, 10 ), feet1Location = int3( 78, 94, 5 ), feet2Location = int3( 11, 96, 5 ), sfx = 5;
                                                           duration = 0.2, pivot = 38, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 474, width = 90, height = 102 ]] ), headLocation = int3( 73, 11, 9 ), bellyLocation = int3( 48, 54, 10 ), feet1Location = int3( 57, 96, 5 ), hitLocation1 = int3( 84, 8, 5 ) }] ]]
                             ;// HeadButtKeep
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.2, pivot = 38, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 474, width = 90, height = 102 ]] ), headLocation = int3( 73, 11, 9 ), bellyLocation = int3( 48, 54, 10 ), feet1Location = int3( 57, 96, 5 ) }] ]]
                             ;// HeadButtEnd
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 864, top = 472, width = 92, height = 104 ]] ), headLocation = int3( 53, 11, 9 ), bellyLocation = int3( 50, 58, 10 ), feet1Location = int3( 69, 98, 5 );
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,   top = 88,  width = 98, height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// HighKickStart
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 432, top = 282, width = 74,  height = 102 ]] ), headLocation = int3( 21, 11, 9 ), bellyLocation = int3( 34, 48, 10 ), feet2Location = int3( 36, 96, 4 ), sfx = 8;
                                                           duration = 0.1, pivot = 63, sprites <- MakeSprite( spritesheet, [[ Area left = 864, top = 102, width = 104, height = 90  ]] ), headLocation = int3( 17, 11, 9 ), bellyLocation = int3( 50, 37, 10 ), feet2Location = int3( 68, 84, 4 );
                                                           duration = 0.2, pivot = 62, sprites <- MakeSprite( spritesheet, [[ Area left = 864, top = 280, width = 128, height = 104 ]] ), headLocation = int3( 15, 27, 9 ), bellyLocation = int3( 52, 46, 10 ), feet2Location = int3( 67, 98, 4 ), hitLocation1 = int3( 123, 6, 3 ) }] ]]
                             ;// HighKickKeep
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.2, pivot = 62, sprites <- MakeSprite( spritesheet, [[ Area left = 864, top = 280, width = 128, height = 104 ]] ), headLocation = int3( 15, 27, 9 ), bellyLocation = int3( 52, 46, 10 ), feet2Location = int3( 67, 98, 4 ) }] ]]
                             ;// HighKickEnd
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 63, sprites <- MakeSprite( spritesheet, [[ Area left = 864, top = 102, width = 104, height = 90  ]] ), headLocation = int3( 17, 11, 9 ), bellyLocation = int3( 50, 37, 10 ), feet2Location = int3( 68, 84, 4 );
                                                           duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 432, top = 282, width = 74,  height = 102 ]] ), headLocation = int3( 21, 11, 9 ), bellyLocation = int3( 34, 48, 10 ), feet2Location = int3( 36, 96, 4 );
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,   top = 88,  width = 98,  height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// DoubleFaceKick
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 720,  top = 1246, width = 80,  height = 98  ]] ), headLocation = int3( 33, 11, 9 ), bellyLocation = int3( 39, 54, 10 ), feet1Location = int3( 69, 92, 5 ), feet2Location = int3( 11, 92, 5 ), sfx = 8;
                                                           duration = 0.1, pivot = 52, sprites <- MakeSprite( spritesheet, [[ Area left = 866,  top = 1230, width = 110, height = 114 ]] ), headLocation = int3( 56, 11, 9 ), bellyLocation = int3( 56, 52, 10 );
                                                           duration = 0.1, pivot = 62, sprites <- MakeSprite( spritesheet, [[ Area left = 1008, top = 1208, width = 140, height = 136 ]] ), headLocation = int3( 70, 14, 9 ), bellyLocation = int3( 70, 42, 10 ), hitLocation1 = int3( 5, 44, 3 ), hitLocation2 = int3( 135, 44, 3 );
                                                           duration = 0.1, pivot = 62, sprites <- MakeSprite( spritesheet, [[ Area left = 1152, top = 1214, width = 140, height = 130 ]] ), headLocation = int3( 70, 15, 9 ), bellyLocation = int3( 70, 46, 10 );
                                                           duration = 0.1, pivot = 52, sprites <- MakeSprite( spritesheet, [[ Area left = 866,  top = 1230, width = 110, height = 114 ]] ), headLocation = int3( 56, 11, 9 ), bellyLocation = int3( 56, 52, 10 );
                                                           duration = 0.1, pivot = 40, sprites <- MakeSprite( spritesheet, [[ Area left = 720,  top = 1246, width = 80,  height = 98  ]] ), headLocation = int3( 33, 11, 9 ), bellyLocation = int3( 39, 54, 10 ), feet1Location = int3( 69, 92, 5 ), feet2Location = int3( 11, 92, 5 );
                                                           duration = 0.1, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 88,   width = 98,  height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]
                             ;// ReverseHighKick
                             [[ Animation interruptable = false,
                                          poses <- [{ Pose duration = 0.1, pivot = 67,  sprites <- MakeSprite( spritesheet, [[ Area left = 0,    top = 1238, width = 96,  height = 106 ]] ), headLocation = int3( 34, 13, 9 ), bellyLocation = int3( 43, 58, 10 ), feet1Location = int3( 80, 100, 5 ), feet2Location = int3( 23, 100, 5 );
                                                           duration = 0.1, pivot = 107, sprites <- MakeSprite( spritesheet, [[ Area left = 144,  top = 1232, width = 90,  height = 112 ]] ), headLocation = int3( 51, 11, 9 ), bellyLocation = int3( 52, 58, 10 ), feet1Location = int3( 35, 102, 5 ), feet2Location = int3( 65, 102, 5 );
                                                           duration = 0.1, pivot = 123, sprites <- MakeSprite( spritesheet, [[ Area left = 288,  top = 1234, width = 102, height = 110 ]] ), headLocation = int3( 63, 11, 9 ), bellyLocation = int3( 50, 52, 10 ), feet1Location = int3( 32, 102, 5 ), sfx = 9, turnaround = true;
                                                           duration = 0.2, pivot = 62,  sprites <- MakeSprite( spritesheet, [[ Area left = 864,  top = 280,  width = 128, height = 104 ]] ), headLocation = int3( 15, 27, 9 ), bellyLocation = int3( 52, 46, 10 ), feet2Location = int3( 67, 98,  4 ), teleport = 88.0, hitLocation1 = int3( 123, 6, 3 ) }] ]]
                             ;// Block
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.2, pivot = 46, sprites <- MakeSprite( spritesheet, [[ Area left = 1296, top = 280, width = 96, height = 104 ]] ), headLocation = int3( 43, 11, 9 ), bellyLocation = int3( 46, 56, 10 ), feet1Location = int3( 82, 98, 5 ), feet2Location = int3( 10, 98, 5 ) }] ]]



                             ;// Worm
                             [[ Animation interruptable = true,
                                          poses <- [{ Pose duration = 0.1, teleport = 0.0, pivot = 0,   sprites <- MakeSprite( propsheet, [[ Area left = 0,   top = 448, width = 12, height = 8 ]] ), headLocation = int3( 37, 11, 9 ), bellyLocation = int3( 40, 56, 10 ), feet1Location = int3( 63, 98, 5 ), feet2Location = int3( 10, 98, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = 0,   sprites <- MakeSprite( propsheet, [[ Area left = 32,  top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 39, 96, 5 ), feet2Location = int3( 19, 96, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = 0,   sprites <- MakeSprite( propsheet, [[ Area left = 64,  top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 33, 56, 10 ), feet1Location = int3( 25, 98, 5 ), feet2Location = int3( 47, 98, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = -2,  sprites <- MakeSprite( propsheet, [[ Area left = 98,  top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 33, 56, 10 ), feet1Location = int3( 41, 96, 5 ), feet2Location = int3( 36, 98, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = -4,  sprites <- MakeSprite( propsheet, [[ Area left = 132, top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = -6,  sprites <- MakeSprite( propsheet, [[ Area left = 166, top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = -6,  sprites <- MakeSprite( propsheet, [[ Area left = 198, top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = -6,  sprites <- MakeSprite( propsheet, [[ Area left = 230, top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = -6,  sprites <- MakeSprite( propsheet, [[ Area left = 262, top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = -8,  sprites <- MakeSprite( propsheet, [[ Area left = 296, top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.1, teleport = 0.0, pivot = -10, sprites <- MakeSprite( propsheet, [[ Area left = 330, top = 448, width = 12, height = 8 ]] ), headLocation = int3( 31, 11, 9 ), bellyLocation = int3( 34, 56, 10 ), feet1Location = int3( 41, 94, 5 ), feet2Location = int3( 17, 96, 5 );
                                                           duration = 0.0, teleport = 12.0 }] ]]
                          ]]


def DrawSensei( x, y: int )
    let w = 52
    let h = 90
    spritesheet |> draw_image_region( float(x) * renderScale.x, float(y - h) * renderScale.y, float4( 0, 1446, w, h ), 0xFFFFFFFF, float2( renderScale.x * float(w), renderScale.y * float(h) ) )
    spritesheet |> draw_image_region( float(x) * renderScale.x, float(y + h) * renderScale.y, float4( 0, 1446, w, h ), 0x30000000, float2( renderScale.x * float(w), -renderScale.y * float(h) ) )

    let bw = 420
    let bh = 93
    spritesheet |> draw_image_region( float(x + w / 2) * renderScale.x, float(y - h - bh) * renderScale.y, float4( 810, 1609, bw, bh ), 0xFFFFFFFF, float2( renderScale.x * float(bw), renderScale.y * float(bh) ) )

    return int2( x + w / 2, y - h - bh )
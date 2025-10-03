#macro BONK_VERSION  "2.1.0"
#macro BONK_DATE     "2025-09-23"

#macro BONK_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro BONK_TYPE_AAB        0
#macro BONK_TYPE_OBB        1
#macro BONK_TYPE_CAPSULE    2
#macro BONK_TYPE_CYLINDER   3
#macro BONK_TYPE_LINE       4
#macro BONK_TYPE_RAY        5
#macro BONK_TYPE_POINT      6
#macro BONK_TYPE_QUAD       7
#macro BONK_TYPE_SPHERE     8
#macro BONK_TYPE_TRIANGLE   9
#macro BONK_TYPE_WORLD     10

#macro BONK_NUMBER_OF_TYPES  11

#macro BONK_PUSH_OUT_NONE      0
#macro BONK_PUSH_OUT_SLIPPERY  1
#macro BONK_PUSH_OUT_GRIPPY    2

#macro BONK_WORLD_CELL_MIN  -1000
#macro BONK_WORLD_CELL_MAX   1000

//Mask sprites (`__BonkMaskAAB` etc.) are 100px square. We use a mask size fractionally smaller
//than that to ensure we don't miss collision due to floating point weirdness or hidden off-by-one
//errors.
#macro BONK_MASK_SIZE  99

//As of runtime v2024.11.0.227, a minimum size less than 1 will lead to GameMaker instances
//refusing to collide.
#macro BONK_INSTANCE_MIN_SIZE  1
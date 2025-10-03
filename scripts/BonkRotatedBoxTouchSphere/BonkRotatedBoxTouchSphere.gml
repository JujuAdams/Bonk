// Feather disable all

/// Returns whether a Bonk rotated box and sphere overlap.
/// 
/// @param box
/// @param sphere

function BonkRotatedBoxTouchSphere(_box, _sphere)
{
    return BonkSphereTouchRotatedBox(_sphere, _box);
}
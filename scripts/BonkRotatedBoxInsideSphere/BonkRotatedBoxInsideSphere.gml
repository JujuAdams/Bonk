// Feather disable all

/// Returns whether a Bonk rotated box and sphere overlap.
/// 
/// @param box
/// @param sphere

function BonkRotatedBoxInsideSphere(_box, _sphere)
{
    return BonkSphereInsideRotatedBox(_sphere, _box);
}
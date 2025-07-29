// Feather disable all

/// Returns whether a Bonk rotated box lies inside a sphere.
/// 
/// @param box
/// @param sphere

function BonkRotatedBoxInsideSphere(_box, _sphere)
{
    return BonkSphereInsideRotatedBox(_sphere, _box);
}
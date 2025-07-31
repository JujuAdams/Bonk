// Feather disable all

/// Returns the "push out" vector that separates a Bonk sphere and AABB.
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The vector that separates the two shapes. If there is no collision, all three variables
///     will be set to `0`.
/// 
/// @param sphere
/// @param aabb

function BonkSphereCollideAABB(_sphere, _aabb)
{
    return BonkAABBCollideSphere(_aabb, _sphere).__Reverse();
}
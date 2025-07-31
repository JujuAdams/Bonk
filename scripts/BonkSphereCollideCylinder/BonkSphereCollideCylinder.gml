// Feather disable all

/// Returns the "push out" vector that separates a Bonk sphere and cylinder.
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
/// @param cylinder

function BonkSphereCollideCylinder(_sphere, _cylinder)
{
    return BonkCylinderCollideSphere(_cylinder, _sphere).__Reverse();
}
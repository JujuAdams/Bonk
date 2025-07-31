// Feather disable all

/// Returns the "push out" vector that separates a Bonk cylinder and AAB.
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
/// @param cylinder
/// @param aab

function BonkCylinderCollideAAB(_cylinder, _aab)
{
    return BonkAABCollideCylinder(_aab, _cylinder).__Reverse();
}
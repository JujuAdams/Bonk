// Feather disable all

/// Returns the "push out" vector that separates a Bonk cylinder and capsule.
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
/// @param capsule

function BonkCylinderCollideCapsule(_cylinder, _capsule)
{
    return BonkCapsuleCollideCylinder(_capsule, _cylinder).__Reverse();
}
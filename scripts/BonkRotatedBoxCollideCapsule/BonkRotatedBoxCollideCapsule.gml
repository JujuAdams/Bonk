// Feather disable all

/// Returns the "push out" vector that separates a Bonk rotated box and capsule.
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
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same struct
///      to be returned.
/// 
/// @param box
/// @param capsule

function BonkRotatedBoxCollideCapsule(_box, _capsule)
{
    return BonkCapsuleCollideRotatedBox(_capsule, _box).__Reverse();
}
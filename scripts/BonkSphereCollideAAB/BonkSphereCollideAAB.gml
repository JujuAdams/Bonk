// Feather disable all

/// Returns the "push out" vector that separates a Bonk sphere and AAB.
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
/// @param sphere
/// @param aab
/// @param [struct]

function BonkSphereCollideAAB(_sphere, _aab, _struct = undefined)
{
    return BonkAABCollideSphere(_aab, _sphere, _struct).__Reverse(_aab);
}
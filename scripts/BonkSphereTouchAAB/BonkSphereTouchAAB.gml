// Feather disable all

/// Returns whether a Bonk sphere and AAB overlap.
/// 
/// @param sphere
/// @param aab

function BonkSphereTouchAAB(_sphere, _aab)
{
    return BonkAABTouchSphere(_aab, _sphere);
}
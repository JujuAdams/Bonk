// Feather disable all

/// Returns whether a Bonk sphere and AAB overlap.
/// 
/// @param sphere
/// @param aab

function BonkSphereInsideAAB(_sphere, _aab)
{
    return BonkAABInsideSphere(_aab, _sphere);
}
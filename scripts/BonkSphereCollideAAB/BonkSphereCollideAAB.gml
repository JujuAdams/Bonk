// Feather disable all

/// @param sphere
/// @param aab
/// @param [struct]

function BonkSphereCollideAAB(_sphere, _aab, _struct = undefined)
{
    return BonkAABCollideSphere(_aab, _sphere, _struct).__Reverse(_aab);
}
// Feather disable all

/// @param quad
/// @param sphere
/// @param [struct]

function BonkQuadCollideSphere(_quad, _sphere, _struct = undefined)
{
    return BonkSphereCollideQuad(_sphere, _quad, _struct).__Reverse(_sphere);
}
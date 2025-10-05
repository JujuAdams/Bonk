// Feather disable all

/// @param triangle
/// @param sphere
/// @param [struct]

function BonkTriangleCollideSphere(_triangle, _sphere, _struct = undefined)
{
    return BonkSphereCollideTriangle(_sphere, _triangle, _struct).__Reverse(_sphere);
}
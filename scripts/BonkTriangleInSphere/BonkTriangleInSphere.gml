// Feather disable all

/// @param triangle
/// @param sphere

function BonkTriangleInSphere(_triangle, _sphere)
{
    return BonkSphereInTriangle(_sphere, _triangle).Reverse();
}
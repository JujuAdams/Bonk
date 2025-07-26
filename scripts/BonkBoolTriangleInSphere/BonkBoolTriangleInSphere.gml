// Feather disable all

/// Returns whether a Bonk triangle and sphere overlap.
/// 
/// @param triangle
/// @param sphere

function BonkBoolTriangleInSphere(_triangle, _sphere)
{
    return BonkBoolSphereInTriangle(_sphere, _triangle);
}
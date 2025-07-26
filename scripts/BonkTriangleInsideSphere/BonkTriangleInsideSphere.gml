// Feather disable all

/// Returns whether a Bonk triangle and sphere overlap.
/// 
/// @param triangle
/// @param sphere

function BonkTriangleInsideSphere(_triangle, _sphere)
{
    return BonkSphereInsideTriangle(_sphere, _triangle);
}
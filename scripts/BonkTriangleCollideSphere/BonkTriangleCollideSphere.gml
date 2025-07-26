// Feather disable all

/// @param triangle
/// @param sphere

function BonkTriangleCollideSphere(_triangle, _sphere)
{
    return BonkSphereCollideTriangle(_sphere, _triangle).__Reverse();
}
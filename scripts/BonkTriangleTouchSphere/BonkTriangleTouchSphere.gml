// Feather disable all

/// Returns whether a Bonk triangle and sphere overlap.
/// 
/// @param triangle
/// @param sphere

function BonkTriangleTouchSphere(_triangle, _sphere)
{
    return BonkSphereTouchTriangle(_sphere, _triangle);
}
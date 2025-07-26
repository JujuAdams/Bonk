// Feather disable all

/// Returns whether a Bonk triangle lies inside a capsule.
/// 
/// @param triangle
/// @param capsule

function BonkBoolTriangleInCapsule(_triangle, _capsule)
{
    return BonkBoolCapsuleInTriangle(_capsule, _triangle);
}
// Feather disable all

/// @param triangle
/// @param capsule

function BonkTriangleInCapsule(_triangle, _capsule)
{
    return BonkCapsuleInTriangle(_capsule, _triangle).Reverse();
}
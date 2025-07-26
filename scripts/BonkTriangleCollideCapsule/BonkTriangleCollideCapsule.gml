// Feather disable all

/// @param triangle
/// @param capsule

function BonkTriangleCollideCapsule(_triangle, _capsule)
{
    return BonkCapsuleCollideTriangle(_capsule, _triangle).Reverse();
}
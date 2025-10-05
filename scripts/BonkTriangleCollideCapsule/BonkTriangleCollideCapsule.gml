// Feather disable all

/// @param triangle
/// @param capsule
/// @param [struct]

function BonkTriangleCollideCapsule(_triangle, _capsule, _struct = undefined)
{
    return BonkCapsuleCollideTriangle(_capsule, _triangle, _struct).__Reverse(_capsule);
}
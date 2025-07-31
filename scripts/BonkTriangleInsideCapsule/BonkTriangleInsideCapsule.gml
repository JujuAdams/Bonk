// Feather disable all

/// Returns whether a Bonk triangle and capsule overlap.
/// 
/// @param triangle
/// @param capsule

function BonkTriangleInsideCapsule(_triangle, _capsule)
{
    return BonkCapsuleInsideTriangle(_capsule, _triangle);
}
// Feather disable all

/// Returns whether a Bonk triangle lies inside a capsule.
/// 
/// @param triangle
/// @param capsule

function BonkTriangleInsideCapsule(_triangle, _capsule)
{
    return BonkCapsuleInsideTriangle(_capsule, _triangle);
}
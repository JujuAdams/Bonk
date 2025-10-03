// Feather disable all

/// Returns whether a Bonk triangle and capsule overlap.
/// 
/// @param triangle
/// @param capsule

function BonkTriangleTouchCapsule(_triangle, _capsule)
{
    return BonkCapsuleTouchTriangle(_capsule, _triangle);
}
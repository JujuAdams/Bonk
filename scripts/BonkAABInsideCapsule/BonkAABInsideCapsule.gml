// Feather disable all

/// Returns whether a Bonk AAB and capsule overlap.
/// 
/// @param aab
/// @param capsule

function BonkAABInsideCapsule(_aab, _capsule)
{
    return BonkCapsuleInsideAAB(_capsule, _aab);
}
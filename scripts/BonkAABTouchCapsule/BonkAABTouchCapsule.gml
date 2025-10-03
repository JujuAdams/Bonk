// Feather disable all

/// Returns whether a Bonk AAB and capsule overlap.
/// 
/// @param aab
/// @param capsule

function BonkAABTouchCapsule(_aab, _capsule)
{
    return BonkCapsuleTouchAAB(_capsule, _aab);
}
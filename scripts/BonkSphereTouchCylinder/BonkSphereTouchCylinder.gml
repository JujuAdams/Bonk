// Feather disable all

/// Returns whether a Bonk sphere and cylinder overlap.
/// 
/// @param sphere
/// @param cylinder

function BonkSphereTouchCylinder(_sphere, _cylinder)
{
    return BonkCylinderTouchSphere(_cylinder, _sphere);
}
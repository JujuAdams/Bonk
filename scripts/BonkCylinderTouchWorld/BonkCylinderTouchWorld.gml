// Feather disable all

/// Returns whether a Bonk cylinder and world overlap.
/// 
/// @param cylinder
/// @param world

function BonkCylinderTouchWorld(_cylinder, _world)
{
    return _world.Touch(_cylinder);
}
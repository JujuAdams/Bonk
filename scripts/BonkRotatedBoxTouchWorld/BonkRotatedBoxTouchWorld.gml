// Feather disable all

/// Returns whether a Bonk rotated box and world overlap.
/// 
/// @param box
/// @param world

function BonkRotatedBoxTouchWorld(_box, _world)
{
    return _world.Touch(_box);
}
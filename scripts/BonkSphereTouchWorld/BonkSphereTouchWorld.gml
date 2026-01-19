// Feather disable all

/// Returns whether a Bonk sphere and world overlap.
/// 
/// @param sphere
/// @param world

function BonkSphereTouchWorld(_sphere, _world)
{
    return _world.Touch(_sphere);
}
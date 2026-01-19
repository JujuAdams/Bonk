// Feather disable all

/// Returns whether a Bonk quad and world overlap.
/// 
/// @param quad
/// @param world

function BonkQuadTouchWorld(_quad, _world)
{
    return _world.Touch(_quad);
}
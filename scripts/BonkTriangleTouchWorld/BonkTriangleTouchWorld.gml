// Feather disable all

/// Returns whether a Bonk triangle and world overlap.
/// 
/// @param triangle
/// @param world

function BonkTriangleTouchWorld(_triangle, _world)
{
    return _world.Touch(_triangle);
}
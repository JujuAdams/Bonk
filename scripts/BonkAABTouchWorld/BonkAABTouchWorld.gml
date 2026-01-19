// Feather disable all

/// Returns whether a Bonk AAB and world overlap.
/// 
/// @param aab
/// @param world

function BonkAABTouchWorld(_aab, _world)
{
    return _world.Touch(_aab);
}
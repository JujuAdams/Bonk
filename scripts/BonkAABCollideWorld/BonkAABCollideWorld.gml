// Feather disable all

/// @param aab
/// @param world
/// @param [struct]

function BonkAABCollideWorld(_aab, _world, _struct = undefined)
{
    return _world.Collide(_aab, undefined, _struct).__Reverse(_world);
}
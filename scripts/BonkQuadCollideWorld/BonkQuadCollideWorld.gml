// Feather disable all

/// @param quad
/// @param world
/// @param [struct]

function BonkQuadCollideWorld(_quad, _world, _struct = undefined)
{
    return _world.Collide(_quad, -1, _struct).__Reverse(_world);
}
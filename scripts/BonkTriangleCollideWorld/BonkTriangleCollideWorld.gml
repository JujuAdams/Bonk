// Feather disable all

/// @param triangle
/// @param world
/// @param [struct]

function BonkTriangleCollideWorld(_triangle, _world, _struct = undefined)
{
    return _world.Collide(_triangle, undefined, _struct).__Reverse(_world);
}
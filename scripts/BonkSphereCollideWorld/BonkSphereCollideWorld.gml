// Feather disable all

/// @param sphere
/// @param world
/// @param [struct]

function BonkSphereCollideWorld(_sphere, _world, _struct = undefined)
{
    return _world.Collide(_sphere, -1, _struct).__Reverse(_world);
}
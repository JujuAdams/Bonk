// Feather disable all

/// @param cylinder
/// @param world
/// @param [struct]

function BonkCylinderCollideWorld(_cylinder, _world, _struct = undefined)
{
    return _world.Collide(_cylinder, -1, _struct).__Reverse(_world);
}
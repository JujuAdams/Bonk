// Feather disable all

/// @param capsule
/// @param world
/// @param [struct]

function BonkCapsuleCollideWorld(_capsule, _world, _struct = undefined)
{
    return _world.Collide(_capsule, -1, _struct).__Reverse(_world);
}
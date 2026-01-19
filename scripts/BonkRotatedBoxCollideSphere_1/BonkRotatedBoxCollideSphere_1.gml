// Feather disable all

/// @param rotatedBox
/// @param world
/// @param [struct]

function BonkRotatedBoxCollideWorld(_rotatedBox, _world, _struct = undefined)
{
    return _world.Collide(_rotatedBox, -1, _struct).__Reverse(_world);
}
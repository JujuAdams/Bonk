// Feather disable all

/// @param shape
/// @param velocityStruct
/// @param [list]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstancePlaceListVelocity(_shape, _velocity, _list = undefined, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    return BonkInstancePlaceList(_shape, _velocity.xSpeed, _velocity.ySpeed, _velocity.zSpeed, _list, _objectXY, _objectXZ);
}
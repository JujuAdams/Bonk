// Feather disable all

/// @param shape
/// @param velocityStruct
/// @param [groupFilter]
/// @param [list]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstancePlaceListVelocity(_shape, _velocity, _groupFilter = undefined, _list = undefined, _objectXY = BonkObjectXY, _objectXZ = BonkObjectXZ)
{
    return BonkInstancePlaceList(_shape, _velocity.xSpeed, _velocity.ySpeed, _velocity.zSpeed, _groupFilter, _list, _objectXY, _objectXZ);
}
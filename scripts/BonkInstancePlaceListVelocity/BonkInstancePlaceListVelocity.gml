// Feather disable all

/// @param shape
/// @param velocityStruct
/// @param [groupFilter]
/// @param [list]
/// @param [object]

function BonkInstancePlaceListVelocity(_shape, _velocity, _groupFilter = undefined, _list = undefined, _object = BonkObject)
{
    return BonkInstancePlaceList(_shape, _velocity.xSpeed, _velocity.ySpeed, _velocity.zSpeed, _groupFilter, _list, _object);
}
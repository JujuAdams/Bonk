// Feather disable all

/// @param shape
/// @param velocityStruct
/// @param [object=BonkObject]
/// @param [groupFilter]
/// @param [list]

function BonkInstancePlaceListVelocity(_shape, _velocity, _object = BonkObject, _groupFilter = undefined, _list = undefined)
{
    return BonkInstancePlaceList(_shape, _velocity.xSpeed, _velocity.ySpeed, _velocity.zSpeed, _object, _groupFilter, _list);
}
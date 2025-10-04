// Feather disable all

/// Works similarly to `BonkInstancePlaceList()`. However, the `dX` and `dY` values are determined
/// using the speed components from a velocity vector. This function therefore is checking ahead of
/// where an instance may be after applying displacement due to velocity.
/// 
/// @param shape
/// @param velocityStruct
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]
/// @param [list]

function BonkInstancePlaceListVelocity(_shape, _velocity, _objectOrArray = BonkObject, _groupFilter = -1, _list = undefined)
{
    return BonkInstancePlaceList(_shape, _velocity.xSpeed, _velocity.ySpeed, _objectOrArray, _groupFilter, _list);
}
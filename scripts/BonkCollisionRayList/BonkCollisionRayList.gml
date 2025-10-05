// Feather disable all

/// Works similarly to `BonkCollisionLineList()` albeit using a ray rather than a line segment.
/// Please note that intersection test happens in the XY plane so z-axis information is not needed
/// by this function.
/// 
/// @param x
/// @param y
/// @param dX
/// @param dY
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]
/// @param [list]
/// @param [length]

function BonkCollisionRayList(_x, _y, _dX, _dY, _objectOrArray = BonkObject, _groupFilter = -1, _list = undefined, _length = BONK_RAY_LENGTH)
{
    return BonkCollisionLineList(_x, _y, _x + _length*_dX, _y + _length*_dY, _objectOrArray, _groupFilter, _list);
}
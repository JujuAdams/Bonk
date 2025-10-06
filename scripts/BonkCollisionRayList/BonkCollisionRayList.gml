// Feather disable all

/// Works similarly to `BonkCollisionLineList()` albeit using a ray rather than a line segment.
/// 
/// @param x
/// @param y
/// @param dX
/// @param dY
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]
/// @param [list]

function BonkCollisionRayList(_x, _y, _dX, _dY, _objectOrArray = BonkObject, _groupFilter = -1, _list = undefined)
{
    return BonkCollisionLineList(_x, _y, _x + BONK_RAY_LENGTH*_dX, _y + BONK_RAY_LENGTH*_dY, _objectOrArray, _groupFilter, _list);
}
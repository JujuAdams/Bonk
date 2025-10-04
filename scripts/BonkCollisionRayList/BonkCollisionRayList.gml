// Feather disable all

/// Works similarly to `BonkCollisionLineList()` albeit using a ray rather than a line segment.
/// Please note that intersection test happens in the XY plane so z-axis information is not needed
/// by this function.
/// 
/// @param x1
/// @param y1
/// @param dX
/// @param dY
/// @param [object=BonkObject]
/// @param [groupFilter]
/// @param [list]
/// @param [length]

function BonkCollisionRayList(_x1, _y1, _dX, _dY, _object = BonkObject, _groupFilter = -1, _list = undefined, _length = BONK_RAY_LENGTH)
{
    return BonkCollisionLineList(_x1, _y1, _x1 + _length*_dX, _y1 + _length*_dY, _object, _groupFilter, _list);
}
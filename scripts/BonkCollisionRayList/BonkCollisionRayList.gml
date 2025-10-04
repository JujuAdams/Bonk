// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param dX
/// @param dY
/// @param dZ
/// @param [object=BonkObject]
/// @param [groupFilter]
/// @param [list]
/// @param [length]

function BonkCollisionRayList(_x1, _y1, _z1, _dX, _dY, _dZ, _object = BonkObject, _groupFilter = -1, _list = undefined, _length = BONK_RAY_LENGTH)
{
    return BonkCollisionLineList(_x1, _y1, _z1, _x1 + _length*_dX, _y1 + _length*_dY, _z1 + _length*_dZ, _object, _groupFilter, _list);
}
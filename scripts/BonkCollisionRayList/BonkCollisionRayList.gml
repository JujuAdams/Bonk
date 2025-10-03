// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param dX
/// @param dY
/// @param dZ
/// @param [groupFilter]
/// @param [list]
/// @param [objectXY]
/// @param [objectXZ]

function BonkCollisionRayList(_x1, _y1, _z1, _dX, _dY, _dZ, _groupFilter = undefined, _list = undefined, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    return BonkCollisionLineList(_x1, _y1, _z1, _x1 + BONK_RAY_LENGTH*_dX, _y1 + BONK_RAY_LENGTH*_dY, _z1 + BONK_RAY_LENGTH*_dZ, _groupFilter, _list, _objectXY, _objectXZ);
}
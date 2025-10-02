// Feather disable all

/// @param shape
/// @param dX
/// @param dY
/// @param dZ
/// @param [array]
/// @param [objectXY]
/// @param [objectXZ]

function BonkRayOverlaps(_x1, _y1, _z1, _dX, _dY, _dZ, _array = undefined, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    return BonkLineOverlaps(_x1, _y1, _z1, _x1 + BONK_RAY_LENGTH*_dX, _y1 + BONK_RAY_LENGTH*_dY, _z1 + BONK_RAY_LENGTH*_dZ, _array, _objectXY, _objectXZ);
}
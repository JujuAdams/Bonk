// Feather disable all

/// @param triangle
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [length]

function BonkRayHitTriangle(_triangle, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _length = BONK_RAY_LENGTH)
{
    return BonkRayHitTriangle(_triangle,
                              _rayX, _rayY, _rayZ,
                              _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ);
}
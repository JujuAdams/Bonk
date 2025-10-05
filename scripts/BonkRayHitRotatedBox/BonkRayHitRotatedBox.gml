// Feather disable all

/// @param box
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [length]
/// @param [struct]

function BonkRayHitRotatedBox(_box, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _length = BONK_RAY_LENGTH, _struct = undefined)
{
    return BonkLineHitRotatedBox(_box,
                                 _rayX, _rayY, _rayZ,
                                 _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ,
                                 _struct);
}
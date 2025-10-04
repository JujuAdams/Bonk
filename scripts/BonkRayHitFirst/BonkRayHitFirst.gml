// Feather disable all

/// @param targetShapes
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [groupFilter]
/// @param [length]

function BonkRayHitFirst(_targetShapes, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _groupFilter = -1, _length = BONK_RAY_LENGTH)
{
    return BonkLineHitFirst(_targetShapes,
                            _rayX, _rayY, _rayZ,
                            _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ,
                            _groupFilter);
}
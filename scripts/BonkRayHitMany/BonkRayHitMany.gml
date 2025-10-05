// Feather disable all

/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]
/// @param [length]

function BonkRayHitMany(_rayX, _rayY, _rayZ, _dX, _dY, _dZ, _objectOrArray = BonkObject, _groupFilter = -1, _length = BONK_RAY_LENGTH)
{
    return BonkLineHitMany(_rayX, _rayY, _rayZ,
                           _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ,
                           _objectOrArray, _groupFilter);
}
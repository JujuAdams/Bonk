// Feather disable all

/// @param world
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [length]
/// @param [groupFilter]

function BonkRayHitWorld(_world, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _length = BONK_RAY_LENGTH, _groupFilter = -1, _struct = undefined)
{
    return BonkLineHitWorld(_world,
                            _rayX, _rayY, _rayZ,
                            _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ,
                            _groupFilter, _struct);
}
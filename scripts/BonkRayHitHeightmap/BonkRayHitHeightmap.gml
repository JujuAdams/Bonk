// Feather disable all

/// @param world
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [groupFilter]

function BonkRayHitWorld(_world, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _groupFilter = -1, _struct = undefined)
{
    return BonkLineHitWorld(_world,
                            _rayX, _rayY, _rayZ,
                            _rayX + BONK_RAY_LENGTH*_dX, _rayY + BONK_RAY_LENGTH*_dY, _rayZ + BONK_RAY_LENGTH*_dZ,
                            _groupFilter, _struct);
}
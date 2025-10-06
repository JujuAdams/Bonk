// Feather disable all

/// @param aab
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [struct]

function BonkRayHitAAB(_aab, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _struct = undefined)
{
    return BonkLineHitAAB(_aab,
                          _rayX, _rayY, _rayZ,
                          _rayX + BONK_RAY_LENGTH*_dX, _rayY + BONK_RAY_LENGTH*_dY, _rayZ + BONK_RAY_LENGTH*_dZ,
                          _struct);
}
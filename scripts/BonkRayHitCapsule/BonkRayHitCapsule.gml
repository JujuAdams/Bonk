// Feather disable all

/// @param capsule
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [length]
/// @param [struct]

function BonkRayHitCapsule(_capsule, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _length = BONK_RAY_LENGTH, _struct = undefined)
{
    return BonkLineHitCapsule(_capsule,
                              _rayX, _rayY, _rayZ,
                              _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ,
                              _struct);
}
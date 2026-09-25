// Feather disable all

/// @param mesh
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [struct]
/// @param [groupFilter]

function BonkRayHitMesh(_mesh, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _struct = undefined, _groupFilter = -1)
{
    return BonkLineHitMesh(_mesh,
                           _rayX, _rayY, _rayZ,
                           _rayX + BONK_RAY_LENGTH*_dX, _rayY + BONK_RAY_LENGTH*_dY, _rayZ + BONK_RAY_LENGTH*_dZ,
                           _struct, _groupFilter);
}
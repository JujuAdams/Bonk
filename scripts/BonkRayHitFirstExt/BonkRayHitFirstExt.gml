// Feather disable all

/// Performs a raycast against the target shapes along a ray. If you'd like to use a Bonk line for
/// raycasting then please use the `.HitFirst()` method on the ray struct.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param targetShapes
/// @param [groupFilter]
/// @param [length]

function BonkRayHitFirstExt(_rayX, _rayY, _rayZ, _dX, _dY, _dZ, _targetShapes, _groupFilter = -1, _length = BONK_RAY_LENGTH)
{
    return BonkLineHitFirstExt(_rayX, _rayY, _rayZ,
                               _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ,
                               _targetShapes, _groupFilter);
}
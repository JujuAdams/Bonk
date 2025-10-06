// Feather disable all

/// Returns an array of hit data (`BonkResultHit`) that the ray touches by iterating over the
/// provided target shapes. If any of the shapes being tested are Bonk worlds then this function
/// will also test for collisions with structs stored inside the Bonk world.
/// 
/// This function will return a statically allocated array. Calling this function multiple times
/// will reuse the same array.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param targetShapes
/// @param [groupFilter]

function BonkRayHitManyExt(_rayX, _rayY, _rayZ, _dX, _dY, _dZ, _targetShapes, _groupFilter = -1)
{
    return BonkLineHitManyExt(_rayX, _rayY, _rayZ,
                              _rayX + BONK_RAY_LENGTH*_dX, _rayY + BONK_RAY_LENGTH*_dY, _rayZ + BONK_RAY_LENGTH*_dZ,
                              _targetShapes, _groupFilter);
}
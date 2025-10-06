// Feather disable all

/// Returns hit data (`BonkResultHit`) for the closest shape that the ray touches by iterating over
/// the provided target shapes. If any of the shapes being tested are Bonk worlds then this
/// function will also test for collisions with structs stored inside the Bonk world. If no hit is
/// found, a `BonkResultHit` struct will still be returned but the `.shape` variable will be set to
/// `undefined`.
/// 
/// This function will return a statically allocated struct. Calling this function multiple times
/// will reuse the same struct.
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
/// @param [length]

function BonkRayHitFirstExt(_rayX, _rayY, _rayZ, _dX, _dY, _dZ, _targetShapes, _groupFilter = -1, _length = BONK_RAY_LENGTH)
{
    return BonkLineHitFirstExt(_rayX, _rayY, _rayZ,
                               _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ,
                               _targetShapes, _groupFilter);
}
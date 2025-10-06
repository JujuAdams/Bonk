// Feather disable all

/// Returns hit data (`BonkResultHit`) for the closest shape that the ray touches by iterating over
/// shapes found within the provided `objectOrArray` parameter. If any of the Bonk shapes being
/// tested are Bonk worlds then this function will also test for collisions with structs stored
/// inside the Bonk world. This means that this function may return hit data for a Bonk struct. If
/// no hit is found, a `BonkResultHit` struct will still be returned but the `.shape` variable will
/// be set to `undefined`.
/// 
/// This function will return a statically allocated struct. Calling this function multiple times
/// will reuse the same struct.
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
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkRayHitFirst(_rayX, _rayY, _rayZ, _dX, _dY, _dZ, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkLineHitFirst(_rayX, _rayY, _rayZ,
                            _rayX + BONK_RAY_LENGTH*_dX, _rayY + BONK_RAY_LENGTH*_dY, _rayZ + BONK_RAY_LENGTH*_dZ,
                            _objectOrArray, _groupFilter);
}
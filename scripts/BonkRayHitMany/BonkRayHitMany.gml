// Feather disable all

/// Returns an array of hit data (`BonkResultHit`) that the ray touches by iterating over shapes
/// found within the provided `objectOrArray` parameter. If any of the Bonk shapes being tested are
/// Bonk worlds then this function will also test for collisions with structs stored inside the
/// Bonk world. This means that this function may return hit data for a Bonk struct.
/// 
/// This function will return a statically allocated array. Calling this function multiple times
/// will reuse the same array.
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
/// @param [length]

function BonkRayHitMany(_rayX, _rayY, _rayZ, _dX, _dY, _dZ, _objectOrArray = BonkObject, _groupFilter = -1, _length = BONK_RAY_LENGTH)
{
    return BonkLineHitMany(_rayX, _rayY, _rayZ,
                           _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ,
                           _objectOrArray, _groupFilter);
}
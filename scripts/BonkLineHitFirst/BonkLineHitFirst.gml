// Feather disable all

/// Returns hit data (`BonkResultHit`) for the closest shape that the line segment touches by
/// iterating over shapes found within the provided `objectOrArray` parameter. If any of the Bonk
/// shapes being tested are Bonk worlds then this function will also test for collisions with
/// structs stored inside the Bonk world. This means that this function may return hit data for a
/// Bonk struct. If no hit is found, a `BonkResultHit` struct will still be returned but the
/// `.shape` variable will be set to `undefined`.
/// 
/// This function will return a statically allocated struct. Calling this function multiple times
/// will reuse the same struct.
/// 
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkLineHitFirst(_x1, _y1, _z1, _x2, _y2, _z2, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkLineHitFirstExt(_x1, _y1, _z1, _x2, _y2, _z2, BonkCollisionLineList(_x1, _y1, _x2, _y2, _objectOrArray), _groupFilter);
}
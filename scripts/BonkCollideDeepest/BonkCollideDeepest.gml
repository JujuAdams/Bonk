// Feather disable all

/// Returns collision data (`BonkResultCollide`) for the deepest collision for the subject instance
/// against shapes found within the provided `objectOrArray` parameter. If any of the Bonk shapes
/// being tested are Bonk worlds then this function will also test for collisions with structs
/// stored inside the Bonk world. This means that this function may return collision data for a
/// Bonk struct. If no collision is found, a `BonkResultCollide` struct will still be returned
/// but the `.shape` variable will be set to `undefined`.
/// 
/// This function will return a statically allocated struct. Calling this function multiple times
/// will reuse the same struct.
/// 
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param subjectInstance
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkCollideDeepest(_subjectInstance, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkCollideDeepestExt(_subjectInstance, BonkInstancePlaceList(_subjectInstance, 0, 0, _objectOrArray), _groupFilter);
}
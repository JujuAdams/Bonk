// Feather disable all

/// Returns `true` if the subject Bonk instance touches any of the Bonk instances provided by the
/// `objectOrArray` parameter. If any of the Bonk shapes being tested are Bonk worlds then this
/// function will also test for collisions with structs stored inside the Bonk world.
/// 
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param subjectInstance
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkTouchAny(_subjectInstance, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkTouchAnyExt(_subjectInstance, BonkInstancePlaceList(_subjectInstance, 0, 0, _objectOrArray), _groupFilter);
}
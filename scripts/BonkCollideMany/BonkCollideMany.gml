// Feather disable all

/// Returns an array of collision data (`BonkResultCollide`) that the subject instance touches by
/// iterating over shapes found within the provided `objectOrArray` parameter. If any of the Bonk
/// shapes being tested are Bonk worlds then this function will also test for collisions with
/// structs stored inside the Bonk world. This means that you may get a mixture of Bonk structs
/// and Bonk instances in the returned collision data.
/// 
/// This function will return a statically allocated array by default. Calling this function
/// multiple times will reuse the same internal array. If you'd like to push results to your own
/// array, please set the optional `array` parameter.
/// 
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param subjectInstance
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkCollideMany(_subjectInstance, _objectOrArray = BonkObject, _groupFilter = -1, _array = undefined)
{
    return BonkCollideManyExt(_subjectInstance, BonkInstancePlaceList(_subjectInstance, 0, 0, _objectOrArray), _groupFilter, _array);
}
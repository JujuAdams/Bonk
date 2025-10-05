// Feather disable all

/// @param subjectInstance
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]
/// @param [array]

function BonkTouchMany(_subjectInstance, _objectOrArray = BonkObject, _groupFilter = -1, _array = undefined)
{
    return BonkTouchManyExt(_subjectInstance, BonkInstancePlaceList(_subjectInstance, 0, 0, _objectOrArray), _groupFilter, _array);
}
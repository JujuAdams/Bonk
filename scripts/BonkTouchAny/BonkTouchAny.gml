// Feather disable all

/// @param subjectInstance
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkTouchAny(_subjectInstance, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkTouchAnyExt(_subjectInstance, BonkInstancePlaceList(_subjectInstance, 0, 0, _objectOrArray), _groupFilter);
}
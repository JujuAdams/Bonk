// Feather disable all

/// @param subjectInstance
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkInstanceTouchAny(_subjectInstance, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkTouchAny(_subjectInstance, BonkInstancePlaceList(_subjectInstance, 0, 0, _objectOrArray), _groupFilter);
}
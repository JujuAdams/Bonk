// Feather disable all

/// @param subjectInstance
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkInstanceDeflectMany(_subjectInstance, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkDeflectMany(_subjectInstance, BonkInstancePlaceList(_subjectInstance, 0, 0, _objectOrArray), _groupFilter);
}
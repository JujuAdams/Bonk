// Feather disable all

/// @param subjectShape
/// @param [groupFilter]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceTouchAny(_subjectShape, _groupFilter = undefined, _objectXY = BonkObjectXY, _objectXZ = BonkObjectXZ)
{
    return BonkTouchAny(_subjectShape, BonkInstancePlaceList(_subjectShape, 0, 0, 0, _groupFilter, _objectXY, _objectXZ));
}
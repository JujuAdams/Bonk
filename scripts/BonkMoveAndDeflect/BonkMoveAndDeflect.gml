// Feather disable all

/// @param subjectInstance
/// @param velocityStruct
/// @param [slopeThreshold=0]
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkMoveAndDeflect(_subjectInstance, _velocityStruct, _slopeThreshold = 0, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkMoveAndDeflectExt(_subjectInstance, _velocityStruct, BonkInstancePlaceListVelocity(_subjectInstance, _velocityStruct, _objectOrArray), _slopeThreshold, _groupFilter);
}
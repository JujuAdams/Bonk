// Feather disable all

/// @param subjectShape
/// @param velocityStruct
/// @param targetShapes
/// @param [slopeThreshold=0]
/// @param [groupFilter]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceMoveAndDeflect(_subjectShape, _velocityStruct, _targetShapes, _slopeThreshold = 0, _groupFilter = undefined, _objectXY = BonkObjectXY, _objectXZ = BonkObjectXZ)
{
    return BonkMoveAndDeflect(_subjectShape, _velocityStruct, BonkInstancePlaceListVelocity(_subjectShape, _velocityStruct, _groupFilter, _objectXY, _objectXZ), _slopeThreshold);
}
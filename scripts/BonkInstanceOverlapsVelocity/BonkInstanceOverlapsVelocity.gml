// Feather disable all

/// @param shape
/// @param velocityStruct
/// @param [array]
/// @param [objectXY]
/// @param [objectXZ]

function BonkCreateanceOverlapsVelocity(_shape, _velocity, _array = undefined, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    return BonkCreateanceOverlaps(_shape, _velocity.xSpeed, _velocity.ySpeed, _velocity.zSpeed, _array, _objectXY, _objectXZ);
}
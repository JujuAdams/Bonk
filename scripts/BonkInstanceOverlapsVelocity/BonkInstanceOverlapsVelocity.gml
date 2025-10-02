// Feather disable all

/// @param shape
/// @param velocityStruct
/// @param [array]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceOverlapsVelocity(_shape, _velocity, _array = undefined, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    return BonkInstanceOverlaps(_shape, _velocity.xSpeed, _velocity.ySpeed, _velocity.zSpeed, _array, _objectXY, _objectXZ);
}
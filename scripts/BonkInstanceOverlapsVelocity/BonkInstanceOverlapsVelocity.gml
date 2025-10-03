// Feather disable all

/// @param shape
/// @param velocityStruct
/// @param [list]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceOverlapsVelocity(_shape, _velocity, _list = undefined, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    return BonkInstanceOverlaps(_shape, _velocity.xSpeed, _velocity.ySpeed, _velocity.zSpeed, _list, _objectXY, _objectXZ);
}
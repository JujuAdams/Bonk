/// @param vector
/// @param normal

function BonkVecReflect(_vector, _normal)
{
    return BonkVecSubtract(_vector, BonkVecMultiply(_normal, 2*BonkVecDot(_vector, _normal)));
}
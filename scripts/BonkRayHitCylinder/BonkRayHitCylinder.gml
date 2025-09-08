// Feather disable all

/// Returns the point of impact where a ray meets a Bonk cylinder. The ray is defined by a starting
/// point (`rayX` `rayY` `rayZ`) and direction (`dX` `dY` `dZ`).
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The point of impact. If there is no collision, all three variables will be set to `0`.
/// 
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same struct
///      to be returned.
/// 
/// @param cylinder
/// @param rayX
/// @param rayY
/// @param rayZ
/// @param dX
/// @param dY
/// @param dZ
/// @param [length]

function BonkRayHitCylinder(_cylinder, _rayX, _rayY, _rayZ, _dX, _dY, _dZ, _length = BONK_RAY_LENGTH)
{
    return BonkLineHitCylinder(_cylinder,
                               _rayX, _rayY, _rayZ,
                               _rayX + _length*_dX, _rayY + _length*_dY, _rayZ + _length*_dZ);
}
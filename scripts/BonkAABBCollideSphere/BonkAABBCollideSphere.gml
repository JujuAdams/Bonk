// Feather disable all

/// Returns the "push out" vector that separates a Bonk AAB and sphere.
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The vector that separates the two shapes. If there is no collision, all three variables
///     will be set to `0`.
/// 
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same struct
///      to be returned.
/// 
/// @param aab
/// @param sphere

function BonkAABCollideSphere(_aab, _sphere)
{
    static _nullData = __Bonk().__nullCollisionData;
    static _reaction     = new __BonkClassCollideData();
    
    with(_aab)
    {
        var _xMin = x - 0.5*xSize;
        var _yMin = y - 0.5*ySize;
        var _zMin = z - 0.5*zSize;
        var _xMax = x + 0.5*xSize;
        var _yMax = y + 0.5*ySize;
        var _zMax = z + 0.5*zSize;
    }
    
    with(_sphere)
    {
        var _sphereX = x;
        var _sphereY = y;
        var _sphereZ = z;
        var _sphereRadius = radius;
    }
    
    var _aabClosestX = clamp(_sphere.x, _xMin, _xMax);
    var _aabClosestY = clamp(_sphere.y, _yMin, _yMax);
    var _aabClosestZ = clamp(_sphere.z, _zMin, _zMax);
    
    var _dX = _aabClosestX - _sphereX;
    var _dY = _aabClosestY - _sphereY;
    var _dZ = _aabClosestZ - _sphereZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist >= _sphereRadius)
    {
        return _nullData;
    }
    
    var _coeff = _sphereRadius / _dist;
    var _sphereClosestX = _coeff*_dX + _sphereX;
    var _sphereClosestY = _coeff*_dY + _sphereY;
    var _sphereClosestZ = _coeff*_dZ + _sphereZ;
    
    with(_reaction)
    {
        dX = _sphereClosestX - _aabClosestX;
        dY = _sphereClosestY - _aabClosestY;
        dZ = _sphereClosestZ - _aabClosestZ;
    }
    
    return _reaction;
}
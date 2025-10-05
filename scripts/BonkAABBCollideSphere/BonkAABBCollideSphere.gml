// Feather disable all

/// @param aab
/// @param sphere
/// @param [struct]

function BonkAABCollideSphere(_aab, _sphere, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
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
        return _reaction.__Null();
    }
    
    var _coeff = _sphereRadius / _dist;
    var _sphereClosestX = _coeff*_dX + _sphereX;
    var _sphereClosestY = _coeff*_dY + _sphereY;
    var _sphereClosestZ = _coeff*_dZ + _sphereZ;
    
    with(_reaction)
    {
        shape = _sphere;
        dX = _sphereClosestX - _aabClosestX;
        dY = _sphereClosestY - _aabClosestY;
        dZ = _sphereClosestZ - _aabClosestZ;
    }
    
    return _reaction;
}
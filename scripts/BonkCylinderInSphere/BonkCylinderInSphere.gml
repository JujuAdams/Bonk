// Feather disable all

/// @param cylinder
/// @param sphere

function BonkCylinderInSphere(_cylinder, _sphere)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_cylinder)
    {
        var _x      = x;
        var _y      = y;
        var _radius = radius;
        var _zMin   = z - 0.5*height;
        var _zMax   = z + 0.5*height;
    }
    
    with(_sphere)
    {
        var _sphereX = x;
        var _sphereY = y;
        var _sphereZ = z;
        var _sphereRadius = radius;
    }
    
    var _dX = _sphereX - _x;
    var _dY = _sphereY - _y;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY);
    if (_dist > _radius)
    {
        var _coeff = _radius / _dist;
        var _cylinderClosestX = _x + _coeff*_dX;
        var _cylinderClosestY = _y + _coeff*_dY;
    }
    else
    {
        var _cylinderClosestX = _sphereX;
        var _cylinderClosestY = _sphereY;
    }
    
    var _cylinderClosestZ = clamp(_sphere.z, _zMin, _zMax);
    
    var _dX = _cylinderClosestX - _sphereX;
    var _dY = _cylinderClosestY - _sphereY;
    var _dZ = _cylinderClosestZ - _sphereZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist >= _sphereRadius)
    {
        return _nullReaction;
    }
    
    var _coeff = _sphereRadius / _dist;
    var _sphereClosestX = _coeff*_dX + _sphereX;
    var _sphereClosestY = _coeff*_dY + _sphereY;
    var _sphereClosestZ = _coeff*_dZ + _sphereZ;
    
    with(_reaction)
    {
        dX = _sphereClosestX - _cylinderClosestX;
        dY = _sphereClosestY - _cylinderClosestY;
        dZ = _sphereClosestZ - _cylinderClosestZ;
    }
    
    return _reaction;
}
// Feather disable all

/// @param aabb
/// @param sphere

function BonkAABBCollideSphere(_aabb, _sphere)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_aabb)
    {
        var _xMin = x - xHalfSize;
        var _yMin = y - yHalfSize;
        var _zMin = z - zHalfSize;
        var _xMax = x + xHalfSize;
        var _yMax = y + yHalfSize;
        var _zMax = z + zHalfSize;
    }
    
    with(_sphere)
    {
        var _sphereX = x;
        var _sphereY = y;
        var _sphereZ = z;
        var _sphereRadius = radius;
    }
    
    var _aabbClosestX = clamp(_sphere.x, _xMin, _xMax);
    var _aabbClosestY = clamp(_sphere.y, _yMin, _yMax);
    var _aabbClosestZ = clamp(_sphere.z, _zMin, _zMax);
    
    var _dX = _aabbClosestX - _sphereX;
    var _dY = _aabbClosestY - _sphereY;
    var _dZ = _aabbClosestZ - _sphereZ;
    
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
        dX = _sphereClosestX - _aabbClosestX;
        dY = _sphereClosestY - _aabbClosestY;
        dZ = _sphereClosestZ - _aabbClosestZ;
    }
    
    return _reaction;
}
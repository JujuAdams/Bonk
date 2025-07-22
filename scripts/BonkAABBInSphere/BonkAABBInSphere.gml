// Feather disable all

/// @param aabb
/// @param sphere

function BonkAABBInSphere(_aabb, _sphere)
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

/*
1) find point 'pbox' on box the closest to the sphere centre.
2) if 'pbox' is outside the sphere no collision.
3) find point 'pshpere' on sphere surface the closest to point 'pbox'.
4) to push sphere on the box surface, 'pbox' should be equal to 'psphere'.
-> Vector delta = (psphere - pbox);
-> float distance =  delta.length();
-> Vector push = delta * (sphere.radius - distance) / distance;
-> sphere.position += push;
-> sphere.velocity -= delta * (sphere.velocity.dotProduct(delta) / delta.dotProduct(delta));
*/
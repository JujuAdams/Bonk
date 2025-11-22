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
    
    if (_dist > 0)
    {
        //Sphere center is outside the box
        
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
    }
    else
    {
        //Sphere center is inside the box
        
        var _lPush     = (_sphereX + _sphereRadius) - _xMin;
        var _tPush     = (_sphereY + _sphereRadius) - _yMin;
        var _belowPush = (_sphereZ + _sphereRadius) - _zMin;
        var _rPush     = _xMax - (_sphereX - _sphereRadius);
        var _bPush     = _yMax - (_sphereY - _sphereRadius);
        var _abovePush = _zMax - (_sphereZ - _sphereRadius);
        
        var _pushX = 0;
        var _pushY = 0;
        var _pushZ = 0;
        
        var _pushDistance = min(_lPush, _tPush, _belowPush, _rPush, _bPush, _abovePush);
        if (_lPush     == _pushDistance) _pushX =  _lPush;
        if (_tPush     == _pushDistance) _pushY =  _tPush;
        if (_belowPush == _pushDistance) _pushZ =  _belowPush;
        if (_rPush     == _pushDistance) _pushX = -_rPush;
        if (_bPush     == _pushDistance) _pushY = -_bPush;
        if (_abovePush == _pushDistance) _pushZ = -_abovePush;
        
        with(_reaction)
        {
            shape = _sphere;
            
            dX = _pushX;
            dY = _pushY;
            dZ = _pushZ;
        }
    }
    
    return _reaction;
}
// Feather disable all

/// @param capsule
/// @param aab
/// @param [struct]

function BonkCapsuleCollideAAB(_capsule, _aab, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    with(_capsule)
    {
        var _capsuleRadius = radius;
        var _capsuleX      = x;
        var _capsuleY      = y;
        var _capsuleZ      = z;
        var _capsuleZMin   = _capsuleZ - 0.5*height + radius;
        var _capsuleZMax   = _capsuleZ + 0.5*height - radius;
    }
    
    with(_aab)
    {
        var _left  = x - 0.5*xSize;
        var _top   = y - 0.5*ySize;
        var _below = z - 0.5*zSize;
        
        var _right  = x + 0.5*xSize;
        var _bottom = y + 0.5*ySize;
        var _above  = z + 0.5*zSize;
        
        var _clampedX = clamp(_capsuleX, _left,  _right);
        var _clampedY = clamp(_capsuleY, _top,   _bottom);
        var _clampedZ = clamp(_capsuleZ, _below, _above);
    }
    
    var _capsuleClosestZ = clamp(_clampedZ, _capsuleZMin, _capsuleZMax);
    
    var _dX = _clampedX - _capsuleX;
    var _dY = _clampedY - _capsuleY;
    var _dZ = _clampedZ - _capsuleClosestZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist >= _capsuleRadius)
    {
        //No collision
        return _reaction.__Null();
    }
    
    if (_dist > 0)
    {
        //Capsule axis is outside the box
        
        var _coeff = _capsuleRadius / _dist;
        var _capsuleClosestX = _coeff*_dX + _capsuleX;
        var _capsuleClosestY = _coeff*_dY + _capsuleY;
        var _capsuleClosestZ = _coeff*_dZ + _capsuleClosestZ;
        
        with(_reaction)
        {
            shape = _aab;
            
            dX = _clampedX - _capsuleClosestX;
            dY = _clampedY - _capsuleClosestY;
            dZ = _clampedZ - _capsuleClosestZ;
        }
    }
    else
    {
        //Capsule axis is inside the box
        
        var _lPush     = (_capsuleX + _capsuleRadius) - _left;
        var _tPush     = (_capsuleY + _capsuleRadius) - _top;
        var _belowPush = (_capsuleZMax + _capsuleRadius) - _below;
        var _rPush     = _right  - (_capsuleX - _capsuleRadius);
        var _bPush     = _bottom - (_capsuleY - _capsuleRadius);
        var _abovePush = _above  - (_capsuleZMin - _capsuleRadius);
        
        var _pushX = 0;
        var _pushY = 0;
        var _pushZ = 0;
        
        var _pushDistance = min(_lPush, _tPush, _belowPush, _rPush, _bPush, _abovePush);
        if (_lPush     == _pushDistance) _pushX = -_lPush;
        if (_tPush     == _pushDistance) _pushY = -_tPush;
        if (_belowPush == _pushDistance) _pushZ = -_belowPush;
        if (_rPush     == _pushDistance) _pushX =  _rPush;
        if (_bPush     == _pushDistance) _pushY =  _bPush;
        if (_abovePush == _pushDistance) _pushZ =  _abovePush;
        
        with(_reaction)
        {
            shape = _aab;
            
            dX = _pushX;
            dY = _pushY;
            dZ = _pushZ;
        }
    }
    
    return _reaction;
}
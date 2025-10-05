// Feather disable all

/// @param capsule
/// @param box
/// @param [struct]

function BonkCapsuleCollideRotatedBox(_capsule, _box, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    with(_capsule)
    {
        var _capsuleX    = x;
        var _capsuleY    = y;
        var _capsuleZMin = z - 0.5*height + radius;
        var _capsuleZMax = z + 0.5*height - radius;
        
        var _capsuleRadius = radius;
    }
    
    with(_box)
    {
        var _left   = -0.5*xSize;
        var _top    = -0.5*ySize;
        var _below  = -0.5*zSize;
        var _right  =  0.5*xSize;
        var _bottom =  0.5*ySize;
        var _above  =  0.5*zSize;
        
        var _capsuleZ = clamp(clamp(_capsule.z, _below, _above), _capsuleZMin, _capsuleZMax);
        
        var _dX = _capsuleX - x;
        var _dY = _capsuleY - y;
        var _dZ = _capsuleZ - z;
        
        //Basis vectors
        var _cos = dcos(zRotation);
        var _sin = dsin(zRotation);
        
        var _iX =  _cos;
        var _iY = -_sin;
        
        var _jX = -_iY;
        var _jY =  _iX;
        
        //Coordinates of the centre of the capsule in the box's frame of reference
        var _i = _dX*_iX + _dY*_iY;
        var _j = _dX*_jX + _dY*_jY;
        var _k = _dZ;
        
        var _pushI = 0;
        var _pushJ = 0;
        var _pushZ = 0;
        
        if ((_i >= _left ) && (_i <= _right )
        &&  (_j >= _top  ) && (_j <= _bottom)
        &&  (_k >= _below) && (_k <= _above ))
        {
            //Centre of capsule is inside the box
            var _lPush     = (_i + _capsuleRadius) - _left;
            var _tPush     = (_j + _capsuleRadius) - _top;
            var _belowPush = (_k + _capsuleRadius) - _below;
            var _rPush     = _right  - (_i - _capsuleRadius);
            var _bPush     = _bottom - (_j - _capsuleRadius);
            var _abovePush = _above  - (_k - _capsuleRadius);
            
            var _pushDistance = min(_lPush, _tPush, _belowPush, _rPush, _bPush, _abovePush);
            if (_lPush     == _pushDistance) _pushI =  _lPush;
            if (_tPush     == _pushDistance) _pushJ =  _tPush;
            if (_belowPush == _pushDistance) _pushZ =  _belowPush;
            if (_rPush     == _pushDistance) _pushI = -_rPush;
            if (_bPush     == _pushDistance) _pushJ = -_bPush;
            if (_abovePush == _pushDistance) _pushZ = -_abovePush;
        }
        else
        {
            var _dX = clamp(_i, _left,  _right ) - _i;
            var _dY = clamp(_j, _top,   _bottom) - _j;
            var _dZ = clamp(_k, _below, _above ) - _k;
            var _d  = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
            
            if (_d >= _capsuleRadius)
            {
                return _reaction.__Null();
            }
            
            _pushDistance = _capsuleRadius - _d;
            var _coeff = _pushDistance / _d;
            var _pushI = _coeff*_dX;
            var _pushJ = _coeff*_dY;
            var _pushZ = _coeff*_dZ;
        }
        
        var _pushX = (_pushI*_iX + _pushJ*_jX);
        var _pushY = (_pushI*_iY + _pushJ*_jY);
        
        with(_reaction)
        {
            shape = _box;
            
            dX = -_pushX;
            dY = -_pushY;
            dZ = -_pushZ;
        }
        
        return _reaction;
    }
    
    return _reaction.__Null();
}
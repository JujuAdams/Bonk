// Feather disable all

/// Returns the "push out" vector that separates a Bonk cylinder and rotated box.
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
/// @param cylinder
/// @param box

function BonkCylinderCollideRotatedBox(_cylinder, _box)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_cylinder)
    {
        var _cylinderX    = x;
        var _cylinderY    = y;
        var _cylinderZMin = z - 0.5*height;
        var _cylinderZMax = z + 0.5*height;
        
        var _cylinderRadius = radius;
    }
    
    with(_box)
    {
        var _boxZMin = z - 0.5*zSize;
        var _boxZMax = z + 0.5*zSize;
        
        //Cylinder and box don't overlap in the z axis
        if ((_boxZMin > _cylinderZMax) && (_boxZMax < _cylinderZMin))
        {
            return _nullReaction;
        }
        
        var _left   = -0.5*xSize;
        var _top    = -0.5*ySize;
        var _right  =  0.5*xSize;
        var _bottom =  0.5*ySize;
        
        var _dX = _cylinderX - x;
        var _dY = _cylinderY - y;
        
        //Basis vectors
        var _cos = dcos(zRotation);
        var _sin = dsin(zRotation);
        
        var _iX =  _cos;
        var _iY = -_sin;
        
        var _jX = -_iY;
        var _jY =  _iX;
        
        //Coordinates of the centre of the sphere in the box's frame of reference
        var _i = _dX*_iX + _dY*_iY;
        var _j = _dX*_jX + _dY*_jY;
        
        if (not rectangle_in_circle(_left, _top, _right, _bottom, _i, _j, _cylinderRadius))
        {
            return _nullReaction;
        }
        
        var _pushI = 0;
        var _pushJ = 0;
        
        if (point_in_rectangle(_i, _j, _left, _top, _right, _bottom))
        {
            //Centre of cylinder is inside the box
            var _lPush = (_i + _cylinderRadius) - _left;
            var _tPush = (_j + _cylinderRadius) - _top;
            var _rPush = _right  - (_i - _cylinderRadius);
            var _bPush = _bottom - (_j - _cylinderRadius);
            
            var _pushDistance = min(_lPush, _tPush, _rPush, _bPush);
            if (_lPush == _pushDistance) _pushI =  _lPush;
            if (_tPush == _pushDistance) _pushJ =  _tPush;
            if (_rPush == _pushDistance) _pushI = -_rPush;
            if (_bPush == _pushDistance) _pushJ = -_bPush;
        }
        else
        {
            var _dX = clamp(_i, _left, _right) - _i;
            var _dY = clamp(_j, _top, _bottom) - _j;
            var _d  = sqrt(_dX*_dX + _dY*_dY);
            
            _pushDistance = _cylinderRadius - _d;
            var _coeff = _pushDistance / _d;
            var _pushI = _coeff*_dX;
            var _pushJ = _coeff*_dY;
        }
        
        var _pushX = (_pushI*_iX + _pushJ*_jX);
        var _pushY = (_pushI*_iY + _pushJ*_jY);
        var _pushZ = 0;
        
        var _pushBelow = _cylinderZMax - _boxZMin; 
        var _pushAbove = _boxZMax - _cylinderZMin; 
        
        if (_pushBelow < _pushDistance)
        {
            _pushX = 0;
            _pushY = 0;
            _pushZ = _pushBelow;
                
            _pushDistance = _pushBelow;
        }
            
        if (_pushAbove < _pushDistance)
        {
            _pushX = 0;
            _pushY = 0;
            _pushZ = -_pushAbove;
        }
        
        with(_reaction)
        {
            dX = -_pushX;
            dY = -_pushY;
            dZ = -_pushZ;
        }
        
        return _reaction;
    }
    
    return _nullReaction;
}
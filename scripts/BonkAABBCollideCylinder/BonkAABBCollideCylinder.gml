// Feather disable all

/// Returns the "push out" vector that separates a Bonk AAB and cylinder.
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
/// @param cylinder
/// @param [struct]

function BonkAABCollideCylinder(_aab, _cylinder, _struct = undefined)
{
    static _staticStruct = new __BonkClassCollideData();
    var _reaction = _struct ?? _staticStruct;
    
    with(_cylinder)
    {
        var _cylinderX = x;
        var _cylinderY = y;
        var _cylinderR = radius;
        
        var _minZ = z - 0.5*height;
        var _maxZ = z + 0.5*height;
    }
    
    with(_aab)
    {
        if ((z - 0.5*zSize >= _maxZ) || (z + 0.5*zSize <= _minZ))
        {
            return _reaction.__Null();
        }
        
        var _left   = x - 0.5*xSize;
        var _top    = y - 0.5*ySize;
        var _below  = z - 0.5*zSize;
        var _right  = x + 0.5*xSize;
        var _bottom = y + 0.5*ySize;
        var _above  = z + 0.5*zSize;
        
        //2D collision check 
        if (not rectangle_in_circle(_left, _top, _right, _bottom, _cylinder.x, _cylinder.y, _cylinder.radius))
        {
            return _reaction.__Null();
        }
        
        var _pushX = 0;
        var _pushY = 0;
        var _pushZ = 0;
        
        if (point_in_rectangle(_cylinder.x, _cylinder.y, _left, _top, _right, _bottom))
        {
            //Centre of cylinder is inside the AAB
            var _lPush = (_cylinderX + _cylinderR) - _left;
            var _tPush = (_cylinderY + _cylinderR) - _top;
            var _rPush = _right  - (_cylinderX - _cylinderR);
            var _bPush = _bottom - (_cylinderY - _cylinderR);
            
            var _pushDistance = min(_lPush, _tPush, _rPush, _bPush);
            if (_lPush == _pushDistance) _pushX =  _lPush;
            if (_tPush == _pushDistance) _pushY =  _tPush;
            if (_rPush == _pushDistance) _pushX = -_rPush;
            if (_bPush == _pushDistance) _pushY = -_bPush;
        }
        else
        {
            var _x = clamp(_cylinderX, _left, _right);
            var _y = clamp(_cylinderY, _top, _bottom);
            
            var _dX = _x - _cylinderX;
            var _dY = _y - _cylinderY;
            var _d  = sqrt(_dX*_dX + _dY*_dY);
            
            var _pushX = _cylinderR*(_dX / _d) - _dX;
            var _pushY = _cylinderR*(_dY / _d) - _dY;
            
            _pushDistance = _cylinderR - _d;
        }
        
        var _pushBelow = _maxZ - _below; 
        var _pushAbove = _above - _minZ; 
        
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
            shape = _cylinder;
            dX = _pushX;
            dY = _pushY;
            dZ = _pushZ;
        }
        
        return _reaction;
    }
}
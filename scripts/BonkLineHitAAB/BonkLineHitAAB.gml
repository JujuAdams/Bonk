// Feather disable all

/// Returns the point of impact where a line meets a Bonk AAB.
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The point of impact. If there is no collision, all three variables will be set to `0`.
/// 
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same struct
///      to be returned.
/// 
/// @param aab
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitAAB(_aab, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullHit = __Bonk().__nullHit;
    static _coordinate = new __BonkClassHit();
    
    with(_aab)
    {
        var _xMin = x - 0.5*xSize;
        var _xMax = x + 0.5*xSize;
        var _yMin = y - 0.5*ySize;
        var _yMax = y + 0.5*ySize;
        var _zMin = z - 0.5*zSize;
        var _zMax = z + 0.5*zSize;
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        if (_dX == 0)
        {
            var _t1 = -infinity;
            var _t2 =  infinity;
        }
        else
        {
            var _t1 = (_xMin - _x1) / _dX;
            var _t2 = (_xMax - _x1) / _dX;
        }
        
        if (_dY == 0)
        {
            var _t3 = -infinity;
            var _t4 =  infinity;
        }
        else
        {
            var _t3 = (_yMin - _y1) / _dY;
            var _t4 = (_yMax - _y1) / _dY;
        }
        
        if (_dZ == 0)
        {
            var _t5 = -infinity;
            var _t6 =  infinity;
        }
        else
        {
            var _t5 = (_zMin - _z1) / _dZ;
            var _t6 = (_zMax - _z1) / _dZ;
        }
        
        var _tMin = max(min(_t1, _t2), min(_t3, _t4), min(_t5, _t6));
        var _tMax = min(max(_t1, _t2), max(_t3, _t4), max(_t5, _t6));
        
        if ((_tMax < 0) || (_tMin > 1) || (_tMin > _tMax))
        {
            return _nullHit;
        }
        
        var _t = (_tMin < 0)? _tMax : _tMin;
        
        var _hitX = _x1 + _t*_dX;
        if (abs(_hitX - x) > 0.5*xSize)
        {
            return _nullHit;
        }
        
        var _hitY = _y1 + _t*_dY;
        if (abs(_hitY - y) > 0.5*ySize)
        {
            return _nullHit;
        }
        
        var _hitZ = _z1 + _t*_dZ;
        if (abs(_hitZ - z) > 0.5*zSize)
        {
            return _nullHit;
        }
        
        with(_coordinate)
        {
            x = _hitX;
            y = _hitY;
            z = _hitZ;
            
            if ((_t == _t1) || (_t == _t2))
            {
                normalX = sign(_hitX - other.x);
                normalY = 0;
                normalZ = 0;
            }
            else if ((_t == _t3) || (_t == _t4))
            {
                normalX = 0;
                normalY = sign(_hitY - other.y);
                normalZ = 0;
            }
            else if ((_t == _t5) || (_t == _t6))
            {
                normalX = 0;
                normalY = 0;
                normalZ = sign(_hitZ - other.z);
            }
        }
        
        return _coordinate;
    }
    
    return _nullHit;
}
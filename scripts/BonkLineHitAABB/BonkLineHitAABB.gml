// Feather disable all

/// @param aabb
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitAABB(_aabb, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullCoordinate = __Bonk().__nullCoordinate;
    static _coordinate     = new __BonkClassCoordinate();
    
    with(_aabb)
    {
        var _xMin = x - xHalfSize;
        var _xMax = x + xHalfSize;
        var _yMin = y - yHalfSize;
        var _yMax = y + yHalfSize;
        var _zMin = z - zHalfSize;
        var _zMax = z + zHalfSize;
        
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
        
        if ((_tMax < 0) || (_tMax > 1) || (_tMin > _tMax))
        {
            return _nullCoordinate;
        }
        
        with(_coordinate)
        {
            var _t = (_tMin < 0)? _tMax : _tMin;
            x = _x1 + _t*_dX;
            y = _y1 + _t*_dY;
            z = _z1 + _t*_dZ;
        }
        
        
        return _coordinate;
    }
    
    return _nullCoordinate;
}
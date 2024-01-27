// Feather disable all

/// @param aabb
/// @param wall

function BonkAABBInWall(_aabb, _wall)
{
    with(_aabb)
    {
        if ((z - zHalfSize > max(_wall.z1, _wall.z2)) || (z + zHalfSize <= min(_wall.z1, _wall.z2))) return false;
        
        var _dX = _wall.x2 - _wall.x1;
        var _dY = _wall.y2 - _wall.y1;
        var _d = sqrt(_dX*_dX + _dY*_dY);
        _dX /= _d;
        _dY /= _d;
        
        var _t1 = (x - xHalfSize - _wall.x1) / _dX;
        var _t2 = (x + xHalfSize - _wall.x1) / _dX;
        var _t3 = (y - yHalfSize - _wall.y1) / _dY;
        var _t4 = (y + yHalfSize - _wall.y1) / _dY;
        
        var _tMin = max(min(_t1, _t2), min(_t3, _t4));
        var _tMax = min(max(_t1, _t2), max(_t3, _t4));
        
        if (_tMin > _d) return false;
        if (_tMax < 0) return false;
        if (_tMin > _tMax) return false;
        
        return true;
    }
    
    return false;
}
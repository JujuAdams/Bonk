// Feather disable all

/// @param cylinder
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkRaycastCylinder(_cylinder, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullCoordinate = __Bonk().__nullCoordiante;
    static _coordinate     = new __BonkClassCoordinate();
    
    with(_cylinder)
    {
        var _cylinderX      = x;
        var _cylinderY      = y;
        var _cylinderZMin   = z - 0.5*height;
        var _cylinderZMax   = z + 0.5*height;
        var _cylinderRadius = radius;
    }
    
    var _dX = _x2 - _x1;
    var _dY = _y2 - _y1;
    var _dZ = _z2 - _z1;
    
    var _vX = _x1 - _cylinderX;
    var _vY = _y1 - _cylinderY;
    
    //Special case - the ray is parallel to the cylinder axis
    if ((_dX == 0) && (_dY == 0))
    {
        if (_dZ == 0)
        {
            return _nullCoordinate;
        }
        
        if (_vX*_vX + _vY*_vY > _cylinderRadius*_cylinderRadius)
        {
            return _nullCoordinate;
        }
        
        var _t = min((_cylinderZMin - _z1) / _dZ, (_cylinderZMax - _z1) / _dZ);
        if ((_t < 0) || (_t > 1))
        {
            return _nullCoordinate;
        }
        
        with(_coordinate)
        {
            x = _x1;
            y = _y1;
            z = _z1 + _t*_dZ;
        }
        
        return _coordinate;
    }
    
    var _a = _dX*_dX + _dY*_dY;
    var _b = 2*(_vX*_dX + _vY*_dY);
    var _c = (_vX*_vX + _vY*_vY) - _cylinderRadius*_cylinderRadius;
    
    var _discriminant = _b*_b - 4*_a*_c;
    if (_discriminant < 0) return _nullCoordinate;
    
    //Handle rays that start inside the cylinder
    _discriminant = sqrt(_discriminant);
    
    if (-_b < _discriminant)
    {
        _discriminant *= -1;
    }
    
    var _t = (-_b - _discriminant) / (2*_a);
    var _z = _z1 + _t*_dZ;
    
    if ((_t >= 0) && (_t <= 1))
    {
        if ((_z >= _cylinderZMin) && (_z <= _cylinderZMax))
        {
            //We hit the body of the cylinder
            with(_coordinate)
            {
                x = _x1 + _t*_dX;
                y = _y1 + _t*_dY;
                z = _z;
            }
            
            return _coordinate;
        }
    }
    
    if (_dZ == 0)
    {
        return _nullCoordinate;
    }
    
    var _tMin = _t;
    var _tMax = (-_b + _discriminant) / (2*_a);
    
    if (_tMax < _tMin)
    {
        return _nullCoordinate;
    }
    
    if (_z > _cylinderZMax)
    {
        //Top cap
        _t = (_cylinderZMax - _z1) / _dZ;
    }
    else
    {
        //Bottom cap
        _t = (_cylinderZMin - _z1) / _dZ;
    }
    
    if ((_t < _tMin) || (_t > _tMax))
    {
        return _nullCoordinate;
    }
    
    with(_coordinate)
    {
        x = _x1 + _t*_dX;
        y = _y1 + _t*_dY;
        z = _z1 + _t*_dZ;
    }
    
    return _coordinate;
}
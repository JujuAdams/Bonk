// Feather disable all

/// @param cylinder
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]

function BonkLineHitCylinder(_cylinder, _x1, _y1, _z1, _x2, _y2, _z2, _struct = undefined)
{
    static _staticHit = new BonkResultHit();
    var _reaction = _struct ?? _staticHit;
    
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
            return _reaction.__Null();
        }
        
        if (_vX*_vX + _vY*_vY > _cylinderRadius*_cylinderRadius)
        {
            return _reaction.__Null();
        }
        
        var _t = min((_cylinderZMin - _z1) / _dZ, (_cylinderZMax - _z1) / _dZ);
        if ((_t < 0) || (_t > 1))
        {
            return _reaction.__Null();
        }
        
        with(_reaction)
        {
            shape = _cylinder;
            
            x = _x1;
            y = _y1;
            z = _z1 + _t*_dZ;
            
            normalX = 0;
            normalY = 0;
            normalZ = sign(z - _cylinder.z);
        }
        
        return _reaction;
    }
    
    //Build a quadratic equation to solve the intersection between the line and an infinitely high
    //cylinder
    var _a = _dX*_dX + _dY*_dY;
    var _b = 2*(_vX*_dX + _vY*_dY);
    var _c = (_vX*_vX + _vY*_vY) - _cylinderRadius*_cylinderRadius;
    
    var _discriminant = _b*_b - 4*_a*_c;
    if (_discriminant < 0) return _reaction.__Null(); //No solutions!
    
    //Handle rays that start inside the cylinder
    _discriminant = sqrt(_discriminant);
    
    if (-_b < _discriminant)
    {
        _discriminant *= -1;
    }
    
    var _t = (-_b - _discriminant) / (2*_a);
    var _z = _z1 + _t*_dZ;
    
    if ((_t >= 0) && (_t <= 1) && (_z >= _cylinderZMin) && (_z <= _cylinderZMax))
    {
        //We hit the body of the cylinder
        
        var _hitX = _x1 + _t*_dX;
        var _hitY = _y1 + _t*_dY;
        
        var _normalX = _hitX - _cylinderX;
        var _normalY = _hitY - _cylinderY;
        
        var _coeff = 1 / sqrt(_normalX*_normalX + _normalY*_normalY);
        _normalX *= _coeff;
        _normalY *= _coeff;
        
        with(_reaction)
        {
            shape = _cylinder;
            
            x = _hitX;
            y = _hitY;
            z = _z;
            
            normalX = _normalX;
            normalY = _normalY;
            normalZ = 0;
        }
        
        return _reaction;
    }
    else
    {
        //We probably hit a cap
        
        //If the ray has no change in z then it cannot hit either cap
        if (_dZ == 0)
        {
            return _reaction.__Null();
        }
        
        //Find the other t value for the intersection with the cylinder
        var _tMin = _t;
        var _tMax = (-_b + _discriminant) / (2*_a);
        
        //Find the t value where the ray intersects with the cap
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
        
        //If this new t value is outside the cylinder then we have no solution
        if ((_t < _tMin) || (_t > _tMax))
        {
            return _reaction.__Null();
        }
        
        with(_reaction)
        {
            shape = _cylinder;
            
            x = _x1 + _t*_dX;
            y = _y1 + _t*_dY;
            z = _z1 + _t*_dZ;
            
            normalX = 0;
            normalY = 0;
            normalZ = sign(z - _cylinder.z);
        }
        
        return _reaction;
    }
}
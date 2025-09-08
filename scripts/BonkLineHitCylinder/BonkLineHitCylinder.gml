// Feather disable all

/// Returns the point of impact where a line meets a Bonk cylinder.
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
/// @param cylinder
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitCylinder(_cylinder, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullHit = __Bonk().__nullHit;
    static _coordinate     = new __BonkClassHit();
    
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
            return _nullHit;
        }
        
        if (_vX*_vX + _vY*_vY > _cylinderRadius*_cylinderRadius)
        {
            return _nullHit;
        }
        
        var _t = min((_cylinderZMin - _z1) / _dZ, (_cylinderZMax - _z1) / _dZ);
        if ((_t < 0) || (_t > 1))
        {
            return _nullHit;
        }
        
        with(_coordinate)
        {
            x = _x1;
            y = _y1;
            z = _z1 + _t*_dZ;
        }
        
        return _coordinate;
    }
    
    //Build a quadratic equation to solve the intersection between the line and an infinitely high
    //cylinder
    var _a = _dX*_dX + _dY*_dY;
    var _b = 2*(_vX*_dX + _vY*_dY);
    var _c = (_vX*_vX + _vY*_vY) - _cylinderRadius*_cylinderRadius;
    
    var _discriminant = _b*_b - 4*_a*_c;
    if (_discriminant < 0) return _nullHit; //No solutions!
    
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
        with(_coordinate)
        {
            x = _x1 + _t*_dX;
            y = _y1 + _t*_dY;
            z = _z;
        }
        
        return _coordinate;
    }
    
    //If the ray has no change in z then it cannot hit either cap
    if (_dZ == 0)
    {
        return _nullHit;
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
        return _nullHit;
    }
    
    with(_coordinate)
    {
        x = _x1 + _t*_dX;
        y = _y1 + _t*_dY;
        z = _z1 + _t*_dZ;
    }
    
    return _coordinate;
}
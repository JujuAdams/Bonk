// Feather disable all

/// Returns the point of impact where a line meets a Bonk capsule.
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The point of impact. If there is no collision, all three variables will be set to `0`.
/// 
/// `.normalX` `.normalY` `.normalZ`
///     The normal of the surface at the point of impact. If there is no collision, a normal of
///     `{0, 0, 1}` will be returned.
/// 
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same
///      struct to be returned.
/// 
/// @param capsule
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitCapsule(_capsule, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullHit = __Bonk().__nullHit;
    static _coordinate     = new __BonkClassHit();
    
    with(_capsule)
    {
        var _capsuleX = x;
        var _capsuleY = y;
        var _capsuleRadius = radius;
        
        var _capsuleZMin = z - 0.5*height + radius;
        var _capsuleZMax = z + 0.5*height - radius;
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        var _vX = _x1 - _capsuleX;
        var _vY = _y1 - _capsuleY;
        
        //Special case - the ray is parallel to the cylinder axis
        if ((_dX == 0) && (_dY == 0))
        {
            if (_dZ == 0)
            {
                return _nullHit;
            }
            
            var _distSqr = _vX*_vX + _vY*_vY
            var _zSqr = _capsuleRadius*_capsuleRadius - _distSqr;
            if (_zSqr < 0)
            {
                //Ray misses the circular cross-section of the cylinder
                return _nullHit;
            }
            
            //Ray starts below the capsule
            if (_z1 < _capsuleZMin - radius)
            {
                if (_dZ <= 0)
                {
                    //Ray pointing the wrong direction, early out
                    return _nullHit;
                }
                
                var _hemisphereZ = _capsuleZMin;
            }
            
            if (_z1 > _capsuleZMax + radius)
            {
                if (_dZ >= 0)
                {
                    //Ray pointing the wrong direction, early out
                    return _nullHit;
                }
                
                var _hemisphereZ = _capsuleZMax;
            }
            
            var _hitX = _x1;
            var _hitY = _y1;
            var _hitZ = _hemisphereZ - sign(_dZ)*sqrt(_zSqr);
            
            var _normalX = _hitX - _capsuleX;
            var _normalY = _hitY - _capsuleY;
            var _normalZ = _hitZ - _hemisphereZ;
            
            var _coeff = 1/sqrt(_normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ);
            _normalX *= _coeff;
            _normalY *= _coeff;
            _normalZ *= _coeff;
            
            with(_coordinate)
            {
                x = _hitX;
                y = _hitY;
                z = _hitZ;
                
                normalX = _normalX;
                normalY = _normalY;
                normalZ = _normalZ;
            }
            
            return _coordinate;
        }
        
        //Build a quadratic equation to solve the intersection between the line and an infinitely high
        //cylinder
        var _a = _dX*_dX + _dY*_dY;
        var _b = 2*(_vX*_dX + _vY*_dY);
        var _c = (_vX*_vX + _vY*_vY) - _capsuleRadius*_capsuleRadius;
        
        var _discriminant = _b*_b - 4*_a*_c;
        if (_discriminant < 0) return _nullHit; //No solutions!
        
        //Handle rays that start inside the cylinder
        _discriminant = sqrt(_discriminant);
        
        if (-_b < _discriminant)
        {
            _discriminant *= -1;
        }
        
        var _t = (-_b - _discriminant) / (2*_a);
        
        var _axisZ = _z1 + _t*_dZ;
        if ((_axisZ <= _capsuleZMin) || (_axisZ >= _capsuleZMax))
        {
            //Choose a sphere centre depending on which end of the capsule the ray is pointed at
            _axisZ = (_axisZ <= 0)? _capsuleZMin : _capsuleZMax;
            
            //Set up a quadratic solution
            var _a = _dX*_dX + _dY*_dY + _dZ*_dZ;
            
            var _b = 2*_dX*(_x1 - _capsuleX) + 2*_dY*(_y1 - _capsuleY) + 2*_dZ*(_z1 - _axisZ);
            
            var _c = _capsuleX*_capsuleX + _capsuleY*_capsuleY + _axisZ*_axisZ
                   + _x1*_x1 + _y1*_y1 + _z1*_z1
                   - 2*(_capsuleX*_x1 + _capsuleY*_y1 + _axisZ*_z1)
                   - _capsuleRadius*_capsuleRadius;
            
            var _discriminant = _b*_b - 4*_a*_c;
            if (_discriminant < 0)
            {
                return _nullHit;
            }
        
            //Handle rays that start inside the cylinder
            _discriminant = sqrt(_discriminant);
            
            if (-_b < _discriminant)
            {
                _discriminant *= -1;
            }
            
            _t = (-_b - _discriminant) / (2*_a);
        }
        
        if ((_t < 0) || (_t > 1))
        {
            return _nullHit;
        }
        
        var _hitX = _x1 + _t*_dX;
        var _hitY = _y1 + _t*_dY;
        var _hitZ = _z1 + _t*_dZ;
        
        var _normalX = _hitX - _capsuleX;
        var _normalY = _hitY - _capsuleY;
        var _normalZ = _hitZ - _axisZ;
        
        var _coeff = 1/sqrt(_normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ);
        _normalX *= _coeff;
        _normalY *= _coeff;
        _normalZ *= _coeff;
        
        with(_coordinate)
        {
            x = _hitX;
            y = _hitY;
            z = _hitZ;
            
            normalX = _normalX;
            normalY = _normalY;
            normalZ = _normalZ;
        }
        
        return _coordinate;
    }
}
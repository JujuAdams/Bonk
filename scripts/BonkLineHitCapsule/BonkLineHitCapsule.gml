// Feather disable all

/// @param capsule
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitCapsule(_capsule, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullCoordinate = __Bonk().__nullCoordinate;
    static _coordinate     = new __BonkClassCoordinate();
    
    with(_capsule)
    {
        var _capsuleX = x;
        var _capsuleY = y;
        var _capsuleRadius = radius;
        
        var _capsuleZMin = z - 0.5*height + radius;
        var _capsuleZMax = z + 0.5*height - radius;
        
        var _capsuleAxisLength = height - 2*radius;
    
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
                return _nullCoordinate;
            }
            
            var _distSqr = _vX*_vX + _vY*_vY
            var _zSqr = _capsuleRadius*_capsuleRadius - _distSqr;
            if (_zSqr < 0)
            {
                //Ray misses the circular cross-section of the cylinder
                return _nullCoordinate;
            }
            
            //Ray starts below the capsule
            if (_z1 < _capsuleZMin - radius)
            {
                if (_dZ <= 0)
                {
                    //Ray pointing the wrong direction, early out
                    return _nullCoordinate;
                }
                
                var _hemisphereZ = _capsuleZMin;
            }
            
            if (_z1 > _capsuleZMax + radius)
            {
                if (_dZ >= 0)
                {
                    //Ray pointing the wrong direction, early out
                    return _nullCoordinate;
                }
                
                var _hemisphereZ = _capsuleZMax;
            }
            
            with(_coordinate)
            {
                x = _x1;
                y = _y1;
                z = _hemisphereZ - sign(_dZ)*sqrt(_zSqr);
            }
            
            return _coordinate;
        }
        
        //Build a quadratic equation to solve the intersection between the line and an infinitely high
        //cylinder
        var _a = _dX*_dX + _dY*_dY;
        var _b = 2*(_vX*_dX + _vY*_dY);
        var _c = (_vX*_vX + _vY*_vY) - _capsuleRadius*_capsuleRadius;
        
        var _discriminant = _b*_b - 4*_a*_c;
        if (_discriminant < 0) return _nullCoordinate; //No solutions!
        
        //Handle rays that start inside the cylinder
        _discriminant = sqrt(_discriminant);
        
        if (-_b < _discriminant)
        {
            _discriminant *= -1;
        }
        
        var _t = (-_b - _discriminant) / (2*_a);
        
        var _z = _z1 + _t*_dZ;
        if ((_z <= _capsuleZMin) || (_z >= _capsuleZMax))
        {
            //Choose a sphere centre depending on which end of the capsule the ray is pointed at
            var _sphereZ = (_z <= 0)? _capsuleZMin : _capsuleZMax;
            
            //Set up a quadratic solution
            var _a = _dX*_dX + _dY*_dY + _dZ*_dZ;
            
            var _b = 2*_dX*(_x1 - _capsuleX) + 2*_dY*(_y1 - _capsuleY) + 2*_dZ*(_z1 - _sphereZ);
            
            var _c = _capsuleX*_capsuleX + _capsuleY*_capsuleY + _sphereZ*_sphereZ
                   + _x1*_x1 + _y1*_y1 + _z1*_z1
                   - 2*(_capsuleX*_x1 + _capsuleY*_y1 + _sphereZ*_z1)
                   - _capsuleRadius*_capsuleRadius;
            
            var _discriminant = _b*_b - 4*_a*_c;
            if (_discriminant < 0)
            {
                return _nullCoordinate;
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
}
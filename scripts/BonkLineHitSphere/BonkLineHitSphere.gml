// Feather disable all

/// @param sphere
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitSphere(_sphere, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullCoordinate = __Bonk().__nullCoordiante;
    static _coordinate     = new __BonkClassCoordinate();
    
    with(_sphere)
    {
        var _sphereX = x;
        var _sphereY = y;
        var _sphereZ = z;
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        var _vX = _sphereX - _x1;
        var _vY = _sphereY - _y1;
        var _vZ = _sphereZ - _z1;
        
        //Set up a quadratic solution
        var _a = _dX*_dX + _dY*_dY + _dZ*_dZ;
        var _b = -2*(_dX*_vX + _dY*_vY + _dZ*_vZ);
        var _c = (_vX*_vX + _vY*_vY + _vZ*_vZ) - radius*radius;
        
        var _discriminant = _b*_b - 4*_a*_c;
        if (_discriminant < 0)
        {
            return _nullCoordinate;
        }
        
        //Catch cases where the start of the ray is inside the sphere
        _discriminant = sqrt(_discriminant);
        if (-_b < _discriminant) _discriminant *= -1;
        
        var _t = (-_b - _discriminant) / (2*_a);
        if (_t > 1)
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
    
    return _nullCoordinate;
}
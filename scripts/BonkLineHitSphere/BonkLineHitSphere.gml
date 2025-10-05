// Feather disable all

/// Returns the point of impact where a line meets a Bonk sphere.
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
/// @param sphere
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]

function BonkLineHitSphere(_sphere, _x1, _y1, _z1, _x2, _y2, _z2, _struct = undefined)
{
    static _staticHit = new __BonkClassHit();
    var _reaction = _struct ?? _staticHit;
    
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
            return _reaction.__Null();
        }
        
        //Catch cases where the start of the ray is inside the sphere
        _discriminant = sqrt(_discriminant);
        if (-_b < _discriminant) _discriminant *= -1;
        
        var _t = (-_b - _discriminant) / (2*_a);
        if (_t > 1)
        {
            return _reaction.__Null();
        }
        
        var _hitX = _x1 + _t*_dX;
        var _hitY = _y1 + _t*_dY;
        var _hitZ = _z1 + _t*_dZ;
        
        var _normalX = _hitX - _sphereX;
        var _normalY = _hitY - _sphereY;
        var _normalZ = _hitZ - _sphereZ;
        
        var _coeff = 1/sqrt(_normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ);
        _normalX *= _coeff;
        _normalY *= _coeff;
        _normalZ *= _coeff;
        
        with(_reaction)
        {
            shape = _sphere;
            
            x = _hitX;
            y = _hitY;
            z = _hitZ;
            
            normalX = _normalX;
            normalY = _normalY;
            normalZ = _normalZ;
        }
        
        return _reaction;
    }
    
    return _reaction.__Null();
}
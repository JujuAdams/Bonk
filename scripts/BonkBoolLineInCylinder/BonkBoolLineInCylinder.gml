// Feather disable all

/// @param line
/// @param cylinder

function BonkBoolLineInCylinder(_line, _cylinder)
{
    with(_line)
    {
        var _dX = x2 - x1;
        var _dY = y2 - y1;
        var _dZ = z2 - z1;
        
        var _a = _dX*_dX + _dY*_dY;
        var _b = 2*(_dX*(x1 - _cylinder.x) + _dY*(y1 - _cylinder.y));
        var _c = sqr(x1 - _cylinder.x) + sqr(y1 - _cylinder.y) - (_cylinder.radius*_cylinder.radius);
        
        var _discriminant = _b*_b - 4*_a*_c;
        if (_discriminant < 0) return false;
        
        var _t0 = clamp((-_b - sqrt(_discriminant)) / (2*_a), 0, 1);
        var _t1 = clamp((-_b + sqrt(_discriminant)) / (2*_a), 0, 1);
        
        var _outZ1 = z1 + _t0*_dZ;
        var _outZ2 = z1 + _t1*_dZ;
        
        return ((_outZ1 >= _cylinder.z - 0.5*_cylinder.height) && (_outZ1 <= _cylinder.z + 0.5*_cylinder.height))
            || ((_outZ2 >= _cylinder.z - 0.5*_cylinder.height) && (_outZ2 <= _cylinder.z + 0.5*_cylinder.height));
    }
    
    return false;
}
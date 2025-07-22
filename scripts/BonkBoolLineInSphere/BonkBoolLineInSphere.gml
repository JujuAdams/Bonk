// Feather disable all

/// @param line
/// @param sphere

function BonkBoolLineInSphere(_line, _sphere)
{
    with(_line)
    {
        var _circleRadius = _sphere.radius;
        
        var _Cx = _sphere.x;
        var _Cy = _sphere.y;
        var _Cz = _sphere.z;
        
        var _Dx = x2 - x1;
        var _Dy = y2 - y1;
        var _Dz = z2 - z1;
        
        var _Lx = _Cx - x1;
        var _Ly = _Cy - y1;
        var _Lz = _Cz - z1;
        
        var _A = _Dx*_Dx + _Dy*_Dy + _Dz*_Dz;
        var _B = -2*(_Dx*_Lx + _Dy*_Ly + _Dz*_Lz);
        var _C = _Lx*_Lx + _Ly*_Ly + _Lz*_Lz - _circleRadius*_circleRadius;
        
        var _discriminant = _B*_B - 4*_A*_C;
        if (_discriminant < 0) return false;
        
        var _t1 = (-_B - sqrt(_discriminant)) / (2*_A);
        if ((_t1 >= 0) && (_t1 <= 1)) return true;
        
        var _t2 = (-_B + sqrt(_discriminant)) / (2*_A);
        if ((_t2 >= 0) && (_t2 <= 1)) return true;
    }
    
    return false;
}
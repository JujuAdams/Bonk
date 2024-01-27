// Feather disable all

/// @param cylinder
/// @param wall

function BonkCylinderInWall(_cylinder, _wall)
{
    with(_cylinder)
    {
        if ((z - 0.5*height > _wall.z2) || (z + 0.5*height <= _wall.z1)) return false;
        
        return __BonkCylinderInWall(x, y, radius, _wall.x1, _wall.y1, _wall.x2, _wall.y2);
    }
    
    return false;
}

function __BonkCylinderInWall(_cx, _cy, _r, _x1, _y1, _x2, _y2)
{
    var _circleRadius = _r;
    
    var _Cx = _cx;
    var _Cy = _cy;
    
    var _Dx = _x2 - _x1;
    var _Dy = _y2 - _y1;
    
    var _Lx = _Cx - _x1;
    var _Ly = _Cy - _y1;
    
    var _A = _Dx*_Dx + _Dy*_Dy;
    var _B = -2*(_Dx*_Lx + _Dy*_Ly);
    var _C = _Lx*_Lx + _Ly*_Ly - _circleRadius*_circleRadius;
    
    var _discriminant = _B*_B - 4*_A*_C;
    if (_discriminant < 0) return false;
    
    var _t1 = (-_B - sqrt(_discriminant)) / (2*_A);
    if ((_t1 >= 0) && (_t1 <= 1)) return true;
    
    var _t2 = (-_B + sqrt(_discriminant)) / (2*_A);
    if ((_t2 >= 0) && (_t2 <= 1)) return true;
    
    return false;
}
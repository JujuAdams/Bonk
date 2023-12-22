// Feather disable all

/// @param cylinder
/// @param wall

function BonkCylinderInWall(_cylinder, _wall)
{
    with(_cylinder)
    {
        if ((z - height > _wall.z2) && (z + height <= _wall.z1)) return false;
        
        return __BonkCylinderInWall(x, y, radius, _wall.x1, _wall.y1, _wall.x2, _wall.y2);
    }
    
    return false;
}

function __BonkCylinderInWall(_cx, _cy, _r, _x1, _y1, _x2, _y2)
{
    var _x  = _x1 - _cx;
    var _y  = _y1 - _cy;
    var _dx = _x2 - _x1;
    var _dy = _y2 - _y1;
    
    var _a = _dx*_dx + _dy*_dy;
    if (_a <= 0) return false;
    
    var _b = 2*(_dx*_x + _dy*_y);
    var _c = _x*_x + _y*_y - _r*_r;
    
    return (_b*_b - 4*_a*_c >= 0);
}
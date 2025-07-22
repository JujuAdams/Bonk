// Feather disable all

/// @param sphere
/// @param wall

function BonkBoolSphereInWall(_sphere, _wall)
{
    with(_sphere)
    {
        var _x = clamp(x, _wall.x1, _wall.x2);
        var _y = clamp(y, _wall.y1, _wall.y2);
        
        var _dX = _wall.x2 - _wall.x1;
        var _dY = _wall.y2 - _wall.y1;
        
        var _d = sqrt(_dX*_dX + _dY*_dY);
        var _t = clamp(dot_product(x - _wall.x1, y - _wall.y1, _dX, _dY) / (_d*_d), 0, 1);
        
        var _x = _wall.x1 + _t*_dX;
        var _y = _wall.y1 + _t*_dY;
        var _z = clamp(z, min(_wall.z1, _wall.z2), max(_wall.z1, _wall.z2));
        
        return (point_distance_3d(_x, _y, _z, x, y, z) < radius);
    }
    
    return false;
}
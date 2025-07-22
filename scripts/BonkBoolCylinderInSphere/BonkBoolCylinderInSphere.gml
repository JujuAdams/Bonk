// Feather disable all

/// @param cylinder
/// @param sphere

function BonkBoolCylinderInSphere(_cylinder, _sphere)
{
    with(_cylinder)
    {
        var _dX = _sphere.x - x;
        var _dY = _sphere.y - y;
        
        var _d = sqrt(_dX*_dX + _dY*_dY);
        _dX /= _d;
        _dY /= _d;
        
        _d = min(radius, _d);
        _dX *= _d;
        _dY *= _d;
        
        var _x = x + _dX;
        var _y = y + _dY;
        var _z = clamp(_sphere.z, z - 0.5*height, z + 0.5*height);
        
        return (point_distance_3d(_x, _y, _z, _sphere.x, _sphere.y, _sphere.z) < _sphere.radius);
    }
    
    return false;
}
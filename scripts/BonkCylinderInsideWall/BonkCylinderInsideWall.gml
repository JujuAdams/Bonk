// Feather disable all

/// Returns whether a Bonk cylinder and wall overlap.
/// 
/// @param cylinder
/// @param wall

function BonkCylinderInsideWall(_cylinder, _wall)
{
    with(_cylinder)
    {
        var _cylinderX      = x;
        var _cylinderY      = y;
        var _cylinderZMin   = z - 0.5*height;
        var _cylinderZMax   = z + 0.5*height;
        var _cylinderRadius = radius;
    }
    
    with(_wall)
    {
        if ((_cylinderZMin > z1) || (_cylinderZMax < z2))
        {
            return false;
        }
        
        var _dX = x2 - x1;
        var _dY = y2 - y1;
        
        var _vX = _cylinderX - x1;
        var _vY = _cylinderY - y1;
        
        var _t = clamp((_vX*_dX + _vY*_dY) / (_dX*_dX + _dY*_dY), 0, 1);
        var _pX = x1 + _t*_dX;
        var _pY = y1 + _t*_dY;
        
        return (point_distance(_cylinderX, _cylinderY, _pX, _pY) < _cylinderRadius);
    }
}
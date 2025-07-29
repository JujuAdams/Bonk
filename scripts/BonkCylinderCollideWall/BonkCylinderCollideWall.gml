// Feather disable all

/// @param cylinder
/// @param wall

function BonkCylinderCollideWall(_cylinder, _wall)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
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
            return _nullReaction;
        }
        
        var _dX = x2 - x1;
        var _dY = y2 - y1;
        
        var _vX = _cylinderX - x1;
        var _vY = _cylinderY - y1;
        
        var _t = clamp((_vX*_dX + _vY*_dY) / (_dX*_dX + _dY*_dY), 0, 1);
        var _pX = x1 + _t*_dX;
        var _pY = y1 + _t*_dY;
        
        var _dX = _cylinderX - _pX;
        var _dY = _cylinderY - _pY;
        
        var _distanceSqr = _dX*_dX + _dY*_dY;
        if (_distanceSqr == 0)
        {
            _distanceSqr = infinity;
        }
        else
        {
            if (_distanceSqr > _cylinderRadius*_cylinderRadius)
            {
                return _nullReaction;
            }
        }
        
        var _distance = sqrt(_distanceSqr);
        
        if (z1 - _cylinderZMin > _cylinderZMax - z2)
        {
            var _dZ = z1 - _cylinderZMin;
        }
        else
        {
            var _dZ = _cylinderZMax - z2;
        }
        
        if (abs(_dZ) < _cylinderRadius - _distance)
        {
            with(_reaction)
            {
                dX = 0;
                dY = 0;
                dZ = _dZ;
            }
        }
        else
        {
            with(_reaction)
            {
                var _coeff = (_cylinderRadius - _distance) / _distance;
                dX = _coeff*_dX;
                dY = _coeff*_dY;
                dZ = 0;
            }
        }
        
        return _reaction;
    }
    
    return _nullReaction;
}
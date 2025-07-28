// Feather disable all

/// @param pole
/// @param cylinder

function BonkPoleCollideCylinder(_pole, _cylinder)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_pole)
    {
        var _x1    = x;
        var _y1    = y;
        var _zMin1 = z - 0.5*height;
        var _zMax1 = z + 0.5*height;
    }
    
    with(_cylinder)
    {
        var _x2     = x;
        var _y2     = y;
        var _zMin2  = z - 0.5*height;
        var _zMax2  = z + 0.5*height;
        var _radius = radius;
    }
    
    var _dX = _x1 - _x2;
    var _dY = _y1 - _y2;
    var _sqrDistance = _dX*_dX + _dY*_dY;
    
    var _pushBelow = _zMin2 - _zMax1;
    var _pushAbove = _zMax2 - _zMin1;
    
    if ((_sqrDistance >= _radius*_radius) || (_pushBelow >= 0) || (_pushAbove <= 0))
    {
        return _nullReaction;
    }
    
    with(_reaction)
    {
        var _distance = sqrt(_sqrDistance);
        var _min = min(_radius - _distance, abs(_pushBelow), abs(_pushAbove));
        if (_min == abs(_pushBelow)) //Prefer z-axis
        {
            dX = 0;
            dY = 0;
            dZ = _pushBelow;
        }
        if (_min == abs(_pushAbove))
        {
            dX = 0;
            dY = 0;
            dZ = _pushAbove;
        }
        else //Then xy plane
        {
            var _coeff = (_radius - _distance) / _distance;
            dX = _coeff*_dX;
            dY = _coeff*_dY;
            dZ = 0;
        }
    }
    
    return _reaction;
}
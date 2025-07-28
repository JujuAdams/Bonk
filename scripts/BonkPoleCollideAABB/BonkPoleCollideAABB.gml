// Feather disable all

/// @param pole
/// @param aabb

function BonkPoleCollideAABB(_pole, _aabb)
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
    
    with(_aabb)
    {
        var _x2    = x;
        var _y2    = y;
        var _xSize = xSize;
        var _ySize = ySize;
        var _zMin2 = z - 0.5*zSize;
        var _zMax2 = z + 0.5*zSize;
    }
    
    var _dX = _x2 - _x1;
    var _dY = _y2 - _y1;
    
    var _pushBelow = _zMin2 - _zMax1;
    var _pushAbove = _zMax2 - _zMin1;
    
    if ((abs(_dX) >= 0.5*_xSize) || (abs(_dY) >= 0.5*_ySize) || (_pushBelow >= 0) || (_pushAbove <= 0))
    {
        return _nullReaction;
    }
    
    _dX -= sign(_dX)*0.5*_xSize;
    _dY -= sign(_dY)*0.5*_ySize;
    
    with(_reaction)
    {
        var _min = min(abs(_dX), abs(_dY), abs(_pushBelow), abs(_pushAbove));
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
        else if (_min == abs(_dX)) //Then x-axis
        {
            dX = _dX;
            dY = 0;
            dZ = 0;
        }
        else if (_min == abs(_dY)) //Then y-axis
        {
            dX = 0;
            dY = _dY;
            dZ = 0;
        }
    }
    
    return _reaction;
}
// Feather disable all

/// Returns the "push out" vector that separates two Bonk AABBs.
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The vector that separates the two shapes. If there is no collision, all three variables
///     will be set to `0`.
/// 
/// @param aabb1
/// @param aabb2

function BonkAABBCollideAABB(_aabb1, _aabb2)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_aabb1)
    {
        var _xMin1 = x - 0.5*xSize;
        var _yMin1 = y - 0.5*ySize;
        var _zMin1 = z - 0.5*zSize;
        var _xMax1 = x + 0.5*xSize;
        var _yMax1 = y + 0.5*ySize;
        var _zMax1 = z + 0.5*zSize;
    }
    
    with(_aabb2)
    {
        var _xMin2 = x - 0.5*xSize;
        var _yMin2 = y - 0.5*ySize;
        var _zMin2 = z - 0.5*zSize;
        var _xMax2 = x + 0.5*xSize;
        var _yMax2 = y + 0.5*ySize;
        var _zMax2 = z + 0.5*zSize;
    }
    
    var _pushLeft  = _xMin2 - _xMax1;
    var _pushRight = _xMax2 - _xMin1;
    
    var _pushUp    = _yMin2 - _yMax1;
    var _pushDown  = _yMax2 - _yMin1;
    
    var _pushBelow = _zMin2 - _zMax1;
    var _pushAbove = _zMax2 - _zMin1;
    
    if ((_pushLeft >= 0) || (_pushRight <= 0) || (_pushUp >= 0) || (_pushDown <= 0) || (_pushBelow >= 0) || (_pushAbove <= 0))
    {
        return _nullReaction;
    }
    
    with(_reaction)
    {
        var _min = min(abs(_pushLeft), abs(_pushRight), abs(_pushUp), abs(_pushDown), abs(_pushBelow), abs(_pushAbove));
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
        else if (_min == abs(_pushLeft)) //Then x-axis
        {
            dX = _pushLeft;
            dY = 0;
            dZ = 0;
        }
        else if (_min == abs(_pushRight))
        {
            dX = _pushRight;
            dY = 0;
            dZ = 0;
        }
        else if (_min == abs(_pushUp)) //Then y-axis
        {
            dX = 0;
            dY = _pushUp;
            dZ = 0;
        }
        else if (_min == abs(_pushDown))
        {
            dX = 0;
            dY = _pushDown;
            dZ = 0;
        }
    }
    
    return _reaction;
}
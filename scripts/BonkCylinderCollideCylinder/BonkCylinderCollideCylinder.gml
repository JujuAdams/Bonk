// Feather disable all

/// Returns the "push out" vector that separates two Bonk cylinders.
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
/// @param cylinder1
/// @param cylinder2

function BonkCylinderCollideCylinder(_cylinder1, _cylinder2)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_cylinder1)
    {
        var _zMin1 = z - 0.5*height;
        var _zMax1 = z + 0.5*height;
        
        var _zMin2 = _cylinder2.z - 0.5*_cylinder2.height;
        var _zMax2 = _cylinder2.z + 0.5*_cylinder2.height;
        
        var _pushBelow = _zMax1 - _zMin2;
        var _pushAbove = _zMax2 - _zMin1;
        
        if ((_pushBelow >= 0) && (_pushAbove <= 0))
        {
            return _nullReaction;
        }
        
        var _dX = x - _cylinder2.x;
        var _dY = y - _cylinder2.y;
        
        var _xyDist = sqrt(_dX*_dX + _dY*_dY);
        if (_xyDist <= 0)
        {
            //Cylinders exactly overlap, fall back on pushing out in the z-axis
            with(_reaction)
            {
                dX = 0;
                dY = 0;
                dZ = _dZ;
            }
            
            return _reaction;
        }
        
        var _pushXY = (radius + _cylinder2.radius) - _xyDist;
        if (_pushXY <= 0)
        {
            return _nullReaction;
        }
        
        with(_reaction)
        {
            var _dZ = (abs(_pushBelow) < abs(_pushAbove))? _pushBelow : _pushAbove;
            if (abs(_dZ) < _pushXY)
            {
                dX = 0;
                dY = 0;
                dZ = _dZ;
            }
            else
            {
                var _coeff = _pushXY / _xyDist;
                dX = _coeff*_dX;
                dY = _coeff*_dY;
                dZ = 0;
            }
        }
        
        return _reaction;
    }
    
    return _nullReaction;
}
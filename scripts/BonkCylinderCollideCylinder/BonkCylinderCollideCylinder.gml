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
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same struct
///      to be returned.
/// 
/// @param cylinder1
/// @param cylinder2
/// @param [struct]

function BonkCylinderCollideCylinder(_cylinder1, _cylinder2, _struct = undefined)
{
    static _staticStruct = new __BonkClassCollideData();
    var _reaction = _struct ?? _staticStruct;
    
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
            return _reaction.__Null();
        }
        
        var _dX = x - _cylinder2.x;
        var _dY = y - _cylinder2.y;
        
        var _xyDist = sqrt(_dX*_dX + _dY*_dY);
        if (_xyDist <= 0)
        {
            //Cylinders exactly overlap, fall back on pushing out in the z-axis
            with(_reaction)
            {
                shape = _cylinder2;
                
                dX = 0;
                dY = 0;
                dZ = _dZ;
            }
            
            return _reaction;
        }
        
        var _pushXY = (radius + _cylinder2.radius) - _xyDist;
        if (_pushXY <= 0)
        {
            return _reaction.__Null();
        }
        
        with(_reaction)
        {
            shape = _cylinder2;
            
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
    
    return _reaction.__Null();
}
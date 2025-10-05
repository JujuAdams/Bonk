// Feather disable all

/// @param sphere1
/// @param sphere2
/// @param [struct]

function BonkSphereCollideSphere(_sphere1, _sphere2, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    var _dX = _sphere1.x - _sphere2.x;
    var _dY = _sphere1.y - _sphere2.y;
    var _dZ = _sphere1.z - _sphere2.z;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist <= 0)
    {
        with(_reaction)
        {
            shape = _sphere2;
            
            //Panic! Pick a randomish direction to push out in
            dX = 1 - 2*floor(abs(_sphere1.x) mod 2);
            dY = 1 - 2*floor(abs(_sphere1.y) mod 2);
            dZ = 1 - 2*floor(abs(_sphere1.z) mod 2);
        }
        
        return _reaction;
    }
    
    var _push = (_sphere1.radius + _sphere2.radius) - _dist;
    if (_push <= 0)
    {
        return _reaction.__Null();
    }
    
    with(_reaction)
    {
        shape = _sphere2;
        
        var _coeff = _push / _dist;
        dX = _coeff*_dX;
        dY = _coeff*_dY;
        dZ = _coeff*_dZ;
    }
    
    return _reaction;
}
// Feather disable all

/// @param sphere1
/// @param sphere2

function BonkSphereInSphere(_sphere1, _sphere2)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    var _dX = _sphere1.x - _sphere2.x;
    var _dY = _sphere1.y - _sphere2.y;
    var _dZ = _sphere1.z - _sphere2.z;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist <= 0)
    {
        with(_reaction)
        {
            var _randomVector = __BonkRandomVector();
            var _dist = _sphere1.radius + _sphere2.radius;
            dX = _dist*_randomVector.x;
            dY = _dist*_randomVector.y;
            dZ = _dist*_randomVector.z;
        }
        
        return _reaction;
    }
    
    var _push = (_sphere1.radius + _sphere2.radius) - _dist;
    if (_push <= 0)
    {
        return _nullReaction;
    }
    
    with(_reaction)
    {
        var _coeff = _push / _dist;
        dX = _coeff*_dX;
        dY = _coeff*_dY;
        dZ = _coeff*_dZ;
    }
    
    return _reaction;
}
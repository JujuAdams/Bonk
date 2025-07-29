// Feather disable all

/// @param pole
/// @param capsule

function BonkPoleCollideCapsule(_pole, _capsule)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_pole)
    {
        var _poleX    = x;
        var _poleY    = y;
        var _poleZMin = z - 0.5*height;
        var _poleZMax = z + 0.5*height;
    }
    
    with(_capsule)
    {
        var _radius = radius;
        
        var _z1 = clamp(z, _poleZMin, _poleZMax);
        var _z2 = clamp(_z1, z - 0.5*height + _radius, z + 0.5*height - _radius);
        
        var _dX = _poleX - x;
        var _dY = _poleY - y;
        var _dZ = _z1 - _z2;
        
        var _distanceSqr = _dX*_dX + _dY*_dY + _dZ*_dZ;
        if (_distanceSqr > _radius*_radius)
        {
            return _nullReaction;
        }
        
        with(_reaction)
        {
            var _distance = sqrt(_distanceSqr);
            var _coeff = (_radius - _distance) / _distance;
            dX = _coeff*_dX;
            dY = _coeff*_dY;
            dZ = _coeff*_dZ;
        }
        
        return _reaction;
    }
    
    return _nullReaction;
}
// Feather disable all

/// @param capsule
/// @param box

function BonkCapsuleCollideRotatedBox(_capsule, _box)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_capsule)
    {
        var _capsuleX    = x;
        var _capsuleY    = y;
        var _capsuleZMin = z - 0.5*height + radius;
        var _capsuleZMax = z + 0.5*height + radius;
        
        var _capsuleRadius = radius;
    }
    
    with(_box)
    {
        var _capsuleZ = clamp(z, _capsuleZMin, _capsuleZMax);
        var _z = clamp(_capsuleZ, z - 0.5*zSize, z + 0.5*zSize);
        
        var _dX = _capsuleX - x;
        var _dY = _capsuleY - y;
        var _dZ = _capsuleZ - _z;
        
        //Basis vectors
        var _cos = dcos(zRotation);
        var _sin = dsin(zRotation);
        
        var _iX =  _cos;
        var _iY = -_sin;
        
        var _jX = -_iY;
        var _jY =  _iX;
        
        //Coordinates of the centre of the capsule in the box's frame of reference
        var _i = _dX*_iX + _dY*_iY;
        var _j = _dX*_jX + _dY*_jY;
        
        //Closest point to the capsule on the box (in the box's frame of reference)
        var _i2 = clamp(_i, -0.5*xSize, 0.5*xSize);
        var _j2 = clamp(_j, -0.5*ySize, 0.5*ySize);
        
        var _dI = _i2 - _i;
        var _dJ = _j2 - _j;
        
        if (_dI*_dI + _dJ*_dJ + _dZ*_dZ >= _capsuleRadius*_capsuleRadius)
        {
            return _nullReaction;
        }
        
        //Closest point to the capsule on the box (in the world frame)
        var _pX = _dI*_iX + _dJ*_jX;
        var _pY = _dI*_iY + _dJ*_jY;
        var _pZ = -_dZ;
        
        with(_reaction)
        {
            var _length = sqrt(_pX*_pX + _pY*_pY + _pZ*_pZ);
            var _coeff = (_capsuleRadius - _length) / _length;
            dX = -_coeff*_pX;
            dY = -_coeff*_pY;
            dZ = -_coeff*_pZ;
        }
        
        return _reaction;
    }
    
    return _nullReaction;
}
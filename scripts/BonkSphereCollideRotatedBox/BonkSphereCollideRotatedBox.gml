// Feather disable all

/// @param sphere
/// @param box

function BonkSphereCollideRotatedBox(_sphere, _box)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_sphere)
    {
        var _sphereX = x;
        var _sphereY = y;
        var _sphereZ = z;
        
        var _sphereRadius = radius;
    }
    
    with(_box)
    {
        var _z = clamp(_sphereZ, z - 0.5*zSize, z + 0.5*zSize);
        
        var _dX = _sphereX - x;
        var _dY = _sphereY - y;
        var _dZ = _sphereZ - _z;
        
        //Basis vectors
        var _cos = dcos(zRotation);
        var _sin = dsin(zRotation);
        
        var _iX =  _cos;
        var _iY = -_sin;
        
        var _jX = -_iY;
        var _jY =  _iX;
        
        //Coordinates of the centre of the sphere in the box's frame of reference
        var _i = _dX*_iX + _dY*_iY;
        var _j = _dX*_jX + _dY*_jY;
        
        //Closest point to the sphere on the box (in the box's frame of reference)
        var _i2 = clamp(_i, -0.5*xSize, 0.5*xSize);
        var _j2 = clamp(_j, -0.5*ySize, 0.5*ySize);
        
        var _dI = _i2 - _i;
        var _dJ = _j2 - _j;
        
        if (_dI*_dI + _dJ*_dJ + _dZ*_dZ >= _sphereRadius*_sphereRadius)
        {
            return _nullReaction;
        }
        
        //Closest point to the sphere on the box (in the world frame)
        var _pX = _dI*_iX + _dJ*_jX;
        var _pY = _dI*_iY + _dJ*_jY;
        var _pZ = -_dZ;
        
        UggLine(_sphereX + _pX, _sphereY + _pY, _sphereZ + _pZ,    _sphereX, _sphereY, _sphereZ);
        
        with(_reaction)
        {
            var _length = sqrt(_pX*_pX + _pY*_pY + _pZ*_pZ);
            var _coeff = (_sphereRadius - _length) / _length;
            dX = -_coeff*_pX;
            dY = -_coeff*_pY;
            dZ = -_coeff*_pZ;
        }
        
        return _reaction;
    }
    
    return _nullReaction;
}
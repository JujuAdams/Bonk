// Feather disable all

/// Returns whether a Bonk capsule and rotated box overlap.
/// 
/// @param capsule
/// @param box

function BonkCapsuleTouchRotatedBox(_capsule, _box)
{
    with(_capsule)
    {
        var _capsuleX    = x;
        var _capsuleY    = y;
        var _capsuleZMin = z - 0.5*height + radius;
        var _capsuleZMax = z + 0.5*height - radius;
        
        var _capsuleRadius = radius;
    }
    
    with(_box)
    {
        var _capsuleZ = clamp(clamp(_capsule.z, z - 0.5*zSize, z + 0.5*zSize), _capsuleZMin, _capsuleZMax);
        
        var _dX = _capsuleX - x;
        var _dY = _capsuleY - y;
        var _dZ = _capsuleZ - z;
        
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
        var _k = _dZ;
        
        //Closest point to the sphere on the box (in the box's frame of reference)
        var _i2 = clamp(_i, -0.5*xSize, 0.5*xSize);
        var _j2 = clamp(_j, -0.5*ySize, 0.5*ySize);
        var _k2 = clamp(_k, -0.5*zSize, 0.5*zSize);
        
        var _dI = _i2 - _i;
        var _dJ = _j2 - _j;
        var _dK = _k2 - _k;
        return (_dI*_dI + _dJ*_dJ + _dK*_dK < _capsuleRadius*_capsuleRadius);
    }
}
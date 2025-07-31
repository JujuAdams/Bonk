// Feather disable all

/// Returns whether a Bonk sphere and rotated box overlap.
/// 
/// @param sphere
/// @param box

function BonkSphereInsideRotatedBox(_sphere, _box)
{
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
        return (_dI*_dI + _dJ*_dJ + _dZ*_dZ < _sphereRadius*_sphereRadius);
    }
}
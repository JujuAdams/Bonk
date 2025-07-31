// Feather disable all

/// Returns whether a Bonk cylinder and rotated box overlap.
/// 
/// @param cylinder
/// @param box

function BonkCylinderInsideRotatedBox(_cylinder, _box)
{
    with(_cylinder)
    {
        var _cylinderX    = x;
        var _cylinderY    = y;
        var _cylinderZMin = z - 0.5*height;
        var _cylinderZMax = z + 0.5*height;
        
        var _cylinderRadius = radius;
    }
    
    with(_box)
    {
        var _cylinderZ = clamp(z, _cylinderZMin, _cylinderZMax);
        var _z = clamp(_cylinderZ, z - 0.5*zSize, z + 0.5*zSize);
        
        //Cylinder and box don't overlap in the z axis
        if (_cylinderZ != _z)
        {
            return false;
        }
        
        var _dX = _cylinderX - x;
        var _dY = _cylinderY - y;
        var _dZ = _cylinderZ - _z;
        
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
        return (_dI*_dI + _dJ*_dJ < _cylinderRadius*_cylinderRadius);
    }
}
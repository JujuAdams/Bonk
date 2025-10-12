// Feather disable all

/// @param capsule
/// @param triangle
/// @param [struct]

function BonkCapsuleCollideTriangle(_capsule, _triangle, _struct = undefined)
{
    with(_capsule)
    {
        var _capsuleHeight = height - 2*radius;
        var _capsuleRadius = radius;
        
        var _capsuleX = x;
        var _capsuleY = y;
        var _capsuleZ = z - 0.5*height + radius;
    }
    
    with(_triangle)
    {
        return __BonkCapsuleCollideTriangle(_capsuleX, _capsuleY, _capsuleZ, _capsuleHeight, _capsuleRadius,
                                            self,
                                            x1, y1, z1,
                                            x2, y2, z2,
                                            x3, y3, z3,
                                            __bonkDX12, __bonkDY12, __bonkDZ12,
                                            __bonkDX23, __bonkDY23, __bonkDZ23,
                                            __bonkDX31, __bonkDY31, __bonkDZ31,
                                            normalX, normalY, normalZ,
                                            __bonkLengthSqr12, __bonkLengthSqr23, __bonkLengthSqr31,
                                            _struct);
    }
}
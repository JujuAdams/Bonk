// Feather disable all

/// Returns whether a Bonk sphere and triangle overlap.
/// 
/// @param sphere
/// @param triangle

function BonkSphereTouchTriangle(_sphere, _triangle)
{
    with(_sphere)
    {
        var _sphereRadius = radius;
        var _sphereX = x;
        var _sphereY = y;
        var _sphereZ = z;
    }
    
    with(_triangle)
    {
        return __BonkSphereTouchTriangle(_sphereX, _sphereY, _sphereZ, _sphereRadius,
                                         x1, y1, z1,
                                         x2, y2, z2,
                                         x3, y3, z3,
                                         __bonkDX12, __bonkDY12, __bonkDZ12,
                                         __bonkDX23, __bonkDY23, __bonkDZ23,
                                         __bonkDX31, __bonkDY31, __bonkDZ31,
                                         normalX, normalY, normalZ,
                                         hardEdge12, hardEdge23, hardEdge31,
                                         __bonkLengthSqr12, __bonkLengthSqr23, __bonkLengthSqr31);
    }
}
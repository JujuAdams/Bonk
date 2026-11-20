// Feather disable all

/// @param sphere
/// @param triangle
/// @param [struct]

function BonkSphereCollideTriangle(_sphere, _triangle, _struct = undefined)
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
        return __BonkSphereCollideTriangle(_sphereX, _sphereY, _sphereZ, _sphereRadius,
                                           self,
                                           x1, y1, z1,
                                           x2, y2, z2,
                                           x3, y3, z3,
                                           hardEdge12, hardEdge23, hardEdge31,
                                           _struct);
    }
}
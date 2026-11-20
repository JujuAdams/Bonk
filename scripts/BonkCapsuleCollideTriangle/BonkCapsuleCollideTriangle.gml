// Feather disable all

/// @param capsule
/// @param triangle
/// @param [struct]

function BonkCapsuleCollideTriangle(_capsule, _triangle, _struct = undefined)
{
    static _staticVector = array_create(4, 0);
    var _vector = _staticVector;
    
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
        if (matrix == undefined)
        {
            return __BonkCapsuleCollideTriangle(_capsuleX, _capsuleY, _capsuleZ, _capsuleHeight, _capsuleRadius,
                                                self,
                                                x1, y1, z1,
                                                x2, y2, z2,
                                                x3, y3, z3,
                                                hardEdge12, hardEdge23, hardEdge31,
                                                _struct);
        }
        else
        {
            var _matrix = matrix;
            
            matrix_transform_vertex(_matrix, x1, y1, z1, 1, _vector);
            var _x1 = _vector[0]; var _y1 = _vector[1]; var _z1 = _vector[2];
            
            matrix_transform_vertex(_matrix, x2, y2, z2, 1, _vector);
            var _x2 = _vector[0]; var _y2 = _vector[1]; var _z2 = _vector[2];
            
            matrix_transform_vertex(_matrix, x3, y3, z3, 1, _vector);
            var _x3 = _vector[0]; var _y3 = _vector[1]; var _z3 = _vector[2];
            
            return __BonkCapsuleCollideTriangle(_capsuleX, _capsuleY, _capsuleZ, _capsuleHeight, _capsuleRadius,
                                                self,
                                                _x1, _y1, _z1,
                                                _x2, _y2, _z2,
                                                _x3, _y3, _z3,
                                                hardEdge12, hardEdge23, hardEdge31,
                                                _struct);
        }
    }
}
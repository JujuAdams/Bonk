// Feather disable all

/// Constructor that generates a triangle. Vertices must be defined in a clockwise order. Triangles
/// can check against the following shapes:
/// - Capsule
/// - Sphere
/// 
/// `.Refresh()`
/// 
/// `.GetAABB()`
///     Returns a struct containing the bounding box for the shape.
/// 
/// `.Draw([color], [thickness], [wireframe])`
///     Draws the shape. This uses Ugg, please see https://github.com/jujuadams/Ugg
/// 
/// `.Touch(otherShape)`
///     Returns whether the two shapes overlap. Not all shapes can be checked against, see above.
/// 
/// `.Collide(otherShape)`
///     Returns the vector that separates two overlapping shapes. Not all shapes can be checked
///     against, see above. This method returns a struct that contains the following variables:
///     
///     `.collision`
///         Whether a collision was found. If no collision is found, this variable is set to `false`.
///     
///     `.x` `.y` `.z`
///         The vector that separates the two shapes. If there is no collision, all three variables
///         will be set to `0`.
/// 
///     N.B. The returned struct is statically allocated. Reusing `.Collide()` may cause the same struct
///          to be returned.
/// 
/// `.Deflect(subjectShape, [slopeThreshold=0])`
///     Pushes the subject shape out of the scoped shape (provided that the two shapes can collide,
///     see above). The slope threshold will allow shapes to "stand" on slopes instead of sliding
///     down them. The units of this parameter are degrees. An angle of `0` represents a perfectly
///     horizontal floor plane. Increase this value to allow shapes to stand on steeper slopes.
/// 
/// The struct created by the constructor contains the following values:
/// 
/// `.x1` `.y1` `.z1`
///     Coordinate of the first coordinate of the triangle.
/// 
/// `.x2` `.y2` `.z2`
///     Coordinate of the second coordinate of the triangle.
/// 
/// `.x3` `.y3` `.z3`
///     Coordinate of the third coordinate of the triangle.
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3

//Set up statics
with(static_get(BonkStructTriangle))
{
    __BonkCommonTriangle();
}

function BonkStructTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) : __BonkClassShared() constructor
{
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    x3 = _x3;
    y3 = _y3;
    z3 = _z3;
    
    Refresh();
    
    
    
    static __SetPositionFree = function() {}
    static __SetPositionInWorld = function() {}
    
    SetPosition = __SetPositionFree;
    
    static Refresh = function()
    {
        dX12 = x2 - x1;
        dY12 = y2 - y1;
        dZ12 = z2 - z1;
        
        dX23 = x3 - x2;
        dY23 = y3 - y2;
        dZ23 = z3 - z2;
        
        dX31 = x1 - x3;
        dY31 = y1 - y3;
        dZ31 = z1 - z3;
        
        lengthSqr12 = dX12*dX12 + dY12*dY12 + dZ12*dZ12;
        lengthSqr23 = dX23*dX23 + dY23*dY23 + dZ23*dZ23;
        lengthSqr31 = dX31*dX31 + dY31*dY31 + dZ31*dZ31;
        
        normalX = dZ12*dY31 - dY12*dZ31;
        normalY = dX12*dZ31 - dZ12*dX31;
        normalZ = dY12*dX31 - dX12*dY31;
        
        var _length = sqrt(normalX*normalX + normalY*normalY + normalZ*normalZ);
        if (_length > 0)
        {
            var _coeff = 1 / _length;
            normalX *= _coeff;
            normalY *= _coeff;
            normalZ *= _coeff;
        }
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggTriangle(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
    
    static GetAABB = function()
    {
        return {
            xMin: min(x1, x2, x3),
            yMin: min(y1, y2, y3),
            zMin: min(z1, z2, z3),
            xMax: max(x1, x2, x3),
            yMax: max(y1, y2, y3),
            zMax: max(z1, z2, z3),
        };
    }
}
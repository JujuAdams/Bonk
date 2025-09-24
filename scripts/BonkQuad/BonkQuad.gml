// Feather disable all

/// Constructor that generates a quad. Vertices must be defined in a clockwise order. Only three
/// vertices need to be provided, the fourth coordinate is automatically generated using the
/// following formulas `P4 = P2 + (P1 - P3)`.
/// 
/// Quads can check against the following shapes:
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
/// `.Inside(otherShape)`
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
/// `.PushOut(subjectShape, [slopeThreshold=0])`
///     Pushes the subject shape out of the scoped shape (provided that the two shapes can collide,
///     see above). The slope threshold will allow shapes to "stand" on slopes instead of sliding
///     down them. The units of this parameter are degrees. An angle of `0` represents a perfectly
///     horizontal floor plane. Increase this value to allow shapes to stand on steeper slopes.
/// 
/// The struct created by the constructor contains the following values:
/// 
/// `.x1` `.y1` `.z1`
///     Coordinate of the first coordinate of the quad.
/// 
/// `.x2` `.y2` `.z2`
///     Coordinate of the second coordinate of the quad.
/// 
/// `.x3` `.y3` `.z3`
///     Coordinate of the third coordinate of the quad.
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

function BonkQuad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_QUAD;
    static lineHitFunction = BonkLineHitQuad;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkQuadCollideCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkQuadCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkQuadInsideCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkQuadInsideSphere;
        return _array;
    })();
    
    
    
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    x3 = _x3;
    y3 = _y3;
    z3 = _z3;
    
    __instanceXY = instance_create_depth(_x1, _y1, 0, __BonkShapeSurrogateXY);
    __instanceXY.__shape = self;
    __instanceXY.sprite_index = __BonkMaskAAB;
    
    //__instanceXZ = instance_create_depth(_x1, _z1, 0, __BonkShapeSurrogateXZ);
    //__instanceXZ.__shape = self;
    //__instanceXZ.sprite_index = __BonkMaskAAB;
    
    Refresh();
    
    
    
    static __SetPositionFree = function() {}
    static __SetPositionInWorld = function() {}
    
    SetPosition = __SetPositionFree;
    
    static Refresh = function()
    {
        dX12 = x2 - x1;
        dY12 = y2 - y1;
        dZ12 = z2 - z1;
        
        dX31 = x1 - x3;
        dY31 = y1 - y3;
        dZ31 = z1 - z3;
        
        dX24 = -dX31;
        dY24 = -dY31;
        dZ24 = -dZ31;
        
        dX43 = -dX12;
        dY43 = -dY12;
        dZ43 = -dZ12;
        
        x4 = x2 + dX24;
        y4 = y2 + dY24;
        z4 = z2 + dZ24;
        
        lengthSqr12 = dX12*dX12 + dY12*dY12 + dZ12*dZ12;
        lengthSqr31 = dX31*dX31 + dY31*dY31 + dZ31*dZ31;
        lengthSqr24 = lengthSqr31;
        lengthSqr43 = lengthSqr12;
        
        normalX = dZ12*dY31 - dY12*dZ31;
        normalY = dX12*dZ31 - dZ12*dX31;
        normalZ = dY12*dX31 - dX12*dY31;
        
        var _coeff = 1 / sqrt(normalX*normalX + normalY*normalY + normalZ*normalZ);
        normalX *= _coeff;
        normalY *= _coeff;
        normalZ *= _coeff;
        
        var _bbox = GetAABB();
        __instanceXY.x = 0.5*(_bbox.xMin + _bbox.xMax);
        __instanceXY.y = 0.5*(_bbox.yMin + _bbox.yMax);
        __instanceXY.image_xscale = max(__BONK_MIN_THICKNESS, _bbox.xMax - _bbox.xMin) / __BONK_MASK_SIZE;
        __instanceXY.image_yscale = max(__BONK_MIN_THICKNESS, _bbox.yMax - _bbox.yMin) / __BONK_MASK_SIZE;
        
        //__instanceXZ.x = 0.5*(_bbox.xMin + _bbox.xMax);
        //__instanceXZ.y = 0.5*(_bbox.zMin + _bbox.zMax);
        //__instanceXZ.image_xscale = max(__BONK_MIN_THICKNESS, _bbox.xMax - _bbox.xMin) / __BONK_MASK_SIZE;
        //__instanceXZ.image_yscale = max(__BONK_MIN_THICKNESS, _bbox.zMax - _bbox.zMin) / __BONK_MASK_SIZE;
    }
    
    static GetAABB = function()
    {
        return {
            xMin: min(x1, x2, x3, x4),
            yMin: min(y1, y2, y3, y4),
            zMin: min(z1, z2, z3, z4),
            xMax: max(x1, x2, x3, x4),
            yMax: max(y1, y2, y3, y4),
            zMax: max(z1, z2, z3, z4),
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggQuad(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
}
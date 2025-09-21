// Feather disable all

/// Constructor that generates a z-aligned capsule. Capsules can check against the following
/// shapes:
/// - AAB
/// - Capsule
/// - Cylinder
/// - Quad
/// - Rotated Box
/// - Sphere
/// - Triangle
/// 
/// `.SetPosition([x], [y], [z])`
/// 
/// `.SetHeight([height])`
/// 
/// `.SetRadius([radius])`
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
/// `.x` `.y` `.z`
///     Coordinate of the centre of the capsule.
/// 
/// `.height`
///     Total height of the capsule.
/// 
/// `.radius`
///     Radius of the capsule.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius

function BonkCapsule(_x, _y, _z, _height, _radius) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_CAPSULE;
    static lineHitFunction = BonkLineHitCapsule;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCapsuleCollideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkCapsuleCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCapsuleCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCapsuleCollideCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkCapsuleCollideQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCapsuleCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkCapsuleCollideTriangle;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCapsuleInsideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkCapsuleInsideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCapsuleInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCapsuleInsideCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkCapsuleInsideQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCapsuleInsideSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkCapsuleInsideTriangle;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    height = _height;
    radius = _radius;
    
    
    
    static __SetPositionFree = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static __SetPositionInWorld = function(_x = x, _y = y, _z = z)
    {
        __world.__MoveShape(_x - x, _y - y, _z - z, self);
        
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    SetPosition = __SetPositionFree;
    
    static SetHeight = function(_height = height)
    {
        height = _height;
        
        return self;
    }
    
    static SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x - radius,
            yMin: y - radius,
            zMin: z - 0.5*height,
            xMax: x + radius,
            yMax: y + radius,
            zMax: z + 0.5*height,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggCapsule(x, y, z - height/2, height, radius, _color, _wireframe);
    }
}
// Feather disable all

/// Constructor that generates a sphere. Spheres can check against the following shapes:
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
///     Returns the vector that separates two shapes overlap. Not all shapes can be checked
///     against, see above. This method returns a struct that contains the following variables:
///     
///     `.collision`
///         Whether a collision was found. If no collision is found, this variable is set to `false`.
///     
///     `.x` `.y` `.z`
///         The vector that separates the two shapes. If there is no collision, all three variables
///         will be set to `0`.
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
///     Coordinate of the centre of the sphere.
/// 
/// `.radius`
///     Radius of the sphere.
/// 
/// @param x
/// @param y
/// @param z
/// @param radius

function BonkSphere(_x, _y, _z, _radius) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_SPHERE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkSphereCollideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkSphereCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkSphereCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkSphereCollideCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkSphereCollideQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkSphereCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkSphereCollideTriangle;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkSphereInsideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkSphereInsideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkSphereInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkSphereInsideCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkSphereInsideQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkSphereInsideSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkSphereInsideTriangle;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
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
            zMin: z - radius,
            xMax: x + radius,
            yMax: y + radius,
            zMax: z + radius,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggSphere(x, y, z, radius, _color, _wireframe);
    }
}
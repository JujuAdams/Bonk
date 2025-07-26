// Feather disable all

/// Constructor that generates a z-aligned capsule.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// 
/// The struct created by the constructor contains the following values:
/// `.x` `.y` `.z`  Coordinate of the centre of the capsule.
/// `.height`       The total height of the capsule.
/// `.radius`       The radius of the capsule (half the thickness of the capsule).
/// 
/// You may use the `.Draw(color, thickness, wireframe)` method to draw the shape, though this
/// method requires installation of Ugg. Please see https://github.com/jujuadams/Ugg
/// 
/// Using the `.Inside(otherShape)` method, this shape can test for an overlap with these shapes:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Quad
/// - Sphere
/// - Triangle
/// 
/// The `.Inside()` method returns either `true` or `false` indicating whether the two shapes
/// overlap. `.Inside()` is usually a little faster than `.Collide()` (see below) and is easier to
/// use.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Quad
/// - Sphere
/// - Triangle
/// 
/// The `.Collide()` method returns a "reaction" struct (instanceof `__BonkClassHit`). This struct
/// has four values:
/// 
/// `.collision`       Boolean, whether the shapes overlap.
/// `.dX` `.dY` `.dZ`  Distance to push ourselves to escape the collision.

function BonkCapsule(_x, _y, _z, _height, _radius) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_CAPSULE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkCapsuleCollideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkCapsuleCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkCapsuleCollideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkCapsuleCollideCylinder;
        _array[@ BONK_TYPE_QUAD        ] = BonkCapsuleCollideQuad;
        _array[@ BONK_TYPE_SPHERE      ] = BonkCapsuleCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE    ] = BonkCapsuleCollideTriangle;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkCapsuleInsideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkCapsuleInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkCapsuleInsideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkCapsuleInsideCylinder;
        _array[@ BONK_TYPE_QUAD        ] = BonkCapsuleInsideQuad;
        _array[@ BONK_TYPE_SPHERE      ] = BonkCapsuleInsideSphere;
        _array[@ BONK_TYPE_TRIANGLE    ] = BonkCapsuleInsideTriangle;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    height = _height;
    radius = _radius;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
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
            x1: x - radius,
            y1: y - radius,
            z1: z - 0.5*height,
            x2: x + radius,
            y2: y + radius,
            z2: z + 0.5*height,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggCapsule(x, y, z - height/2, height, radius, _color, _wireframe);
    }
}
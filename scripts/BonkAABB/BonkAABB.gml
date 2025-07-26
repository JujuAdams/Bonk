// Feather disable all

/// Constructor that generates an axis-aligned bounding box. Such a box cannot be rotated.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// 
/// The struct created by the constructor contains the following values:
/// `.x` `.y` `.z`  Coordinate of the centre of the AABB.
/// `.x2` `.y2` `.z2`  Coordinate of the destination of the ray.
/// 
/// You may use the `.Draw(color, thickness, wireframe)` method to draw the shape, though this
/// method requires installation of Ugg. Please see https://github.com/jujuadams/Ugg
/// 
/// Using the `.Inside(otherShape)` method, this shape can test for an overlap with these shapes:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Sphere
/// 
/// The `.Inside()` method returns either `true` or `false` indicating whether the two shapes
/// overlap. `.Inside()` is usually a little faster than `.Collide()` (see below) and is easier to
/// use.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Sphere
/// 
/// The `.Collide()` method returns a "reaction" struct (instanceof `__BonkClassHit`). This struct
/// has four values:
/// 
/// `.collision`       Boolean, whether the shapes overlap.
/// `.dX` `.dY` `.dZ`  Distance to push ourselves to escape the collision.

function BonkAABB(_x, _y, _z, _xSize, _ySize, _zSize) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_AABB;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkAABBCollideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkAABBCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkAABBCollideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkAABBCollideCylinder;
        _array[@ BONK_TYPE_SPHERE      ] = BonkAABBCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkAABBInsideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkAABBInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkAABBInsideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkAABBInsideCylinder;
        _array[@ BONK_TYPE_SPHERE      ] = BonkAABBInsideSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    xHalfSize = 0.5*_xSize;
    yHalfSize = 0.5*_ySize;
    zHalfSize = 0.5*_zSize;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetSize = function(_x = 2*xHalfSize, _y = 2*yHalfSize, _z = 2*zHalfSize)
    {
        xHalfSize = 0.5*_x;
        yHalfSize = 0.5*_y;
        zHalfSize = 0.5*_z;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            x1: x - xHalfSize,
            y1: y - yHalfSize,
            z1: z - zHalfSize,
            x2: x + xHalfSize,
            y2: y + yHalfSize,
            z2: z + zHalfSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggAABB(x, y, z, 2*xHalfSize, 2*yHalfSize, 2*zHalfSize, _color, _wireframe);
    }
}
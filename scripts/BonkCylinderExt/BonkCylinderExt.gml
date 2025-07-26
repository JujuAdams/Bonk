// Feather disable all

/// Constructor that generates a z-aligned cylinder with additional collisions. When colliding with
/// quads and triangles, this shape will use a capsule-shaped collider. This makes `CylinderExt`
/// helpful for moving characters where predictable motion at the edge of AABBs and cylinders is
/// desired.
/// 
/// Using the `.Inside(otherShape)` method, this shape can test for an overlap with these shapes:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Quad
/// - Sphere
/// - Triangle
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
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius

function BonkCylinderExt(_x, _y, _z, _height, _radius) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_CYLINDER_EXT;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkCylinderCollideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkCylinderCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkCylinderCollideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkCylinderCollideCylinder;
        _array[@ BONK_TYPE_QUAD        ] = BonkCapsuleCollideQuad;
        _array[@ BONK_TYPE_SPHERE      ] = BonkCylinderCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE    ] = BonkCapsuleCollideTriangle;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkCylinderInsideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkCylinderInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkCylinderInsideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkCylinderInsideCylinder;
        _array[@ BONK_TYPE_QUAD        ] = BonkCapsuleInsideQuad;
        _array[@ BONK_TYPE_SPHERE      ] = BonkCylinderInsideSphere;
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
        UggCylinder(x, y, z - height/2, height, radius, _color, _wireframe);
    }
}
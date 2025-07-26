// Feather disable all

/// Constructor that generates a sphere.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Quad
/// - Sphere
/// - Triangle
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
        _array[@ BONK_TYPE_AABB        ] = BonkSphereCollideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkSphereCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkSphereCollideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkSphereCollideCylinder;
        _array[@ BONK_TYPE_QUAD        ] = BonkSphereCollideQuad;
        _array[@ BONK_TYPE_SPHERE      ] = BonkSphereCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE    ] = BonkSphereCollideTriangle;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkSphereInsideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkSphereInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkSphereInsideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkSphereInsideCylinder;
        _array[@ BONK_TYPE_QUAD        ] = BonkSphereInsideQuad;
        _array[@ BONK_TYPE_SPHERE      ] = BonkSphereInsideSphere;
        _array[@ BONK_TYPE_TRIANGLE    ] = BonkSphereInsideTriangle;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    radius = _radius;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
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
            z1: z - radius,
            x2: x + radius,
            y2: y + radius,
            z2: z + radius,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggSphere(x, y, z, radius, _color, _wireframe);
    }
}
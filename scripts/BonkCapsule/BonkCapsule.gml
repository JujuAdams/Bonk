// Feather disable all

/// Constructor that generates a z-aligned capsule.
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
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB    ] = BonkCapsuleCollideAABB;
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
        _array[@ BONK_TYPE_AABB    ] = BonkCapsuleInsideAABB;
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
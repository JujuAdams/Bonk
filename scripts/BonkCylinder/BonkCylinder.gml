// Feather disable all

/// Constructor that generates a z-aligned cylinder.
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
///     Coordinate of the centre of the cylinder.
/// 
/// `.height`
///     Total height of the cylinder.
/// 
/// `.radius`
///     Radius of the cylinder.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius

function BonkCylinder(_x, _y, _z, _height, _radius) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_CYLINDER;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB    ] = BonkCylinderCollideAABB;
        _array[@ BONK_TYPE_OBB     ] = BonkCylinderCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCylinderCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCylinderCollideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCylinderCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB    ] = BonkCylinderInsideAABB;
        _array[@ BONK_TYPE_OBB     ] = BonkCylinderInsideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCylinderInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCylinderInsideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCylinderInsideSphere;
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
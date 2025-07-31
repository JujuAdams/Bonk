// Feather disable all

/// Constructor that generates a box that can be rotated around the z-axis.
/// 
/// `.SetPosition([x], [y], [z])`
/// 
/// `.SetSize([dX], [dY], [dZ])`
/// 
/// `.SetRotation([zRotation])`
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
///     Coordinate of the centre of the box.
/// 
/// `.xSize` `.ySize` `.zSize`
///     Size of the box in each axis.
/// 
/// `.zRotation`
///     Rotation of the box around the z-axis.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation

function BonkRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_OBB;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE ] = BonkRotatedBoxCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkRotatedBoxCollideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkRotatedBoxCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE ] = BonkRotatedBoxInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkRotatedBoxInsideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkRotatedBoxInsideSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    zRotation = _zRotation;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetSize = function(_x = xSize, _y = ySize, _z = zSize)
    {
        xSize = _x;
        ySize = _y;
        zSize = _z;
        
        return self;
    }
    
    static SetRotation = function(_zRotation = zRotation)
    {
        zRotation = _zRotation;
        
        return self;
    }
    
    static GetAABB = function()
    {
        //TODO - Do this properly
        return {
            xMin: x - sqrt(2)*max(xSize, ySize),
            yMin: y - sqrt(2)*max(xSize, ySize),
            zMin: z - 0.5*zSize,
            xMax: x + sqrt(2)*max(xSize, ySize),
            yMax: y + sqrt(2)*max(xSize, ySize),
            zMax: z + 0.5*zSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRotatedBox(x, y, z,   xSize, ySize, zSize,  zRotation,   _color, _wireframe);
    }
}
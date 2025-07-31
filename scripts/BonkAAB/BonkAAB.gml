// Feather disable all

/// Constructor that generates an axis-aligned box.
/// 
/// `.SetPosition([x], [y], [z])`
/// 
/// `.SetSize([dX], [dY], [dZ])`
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
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize

function BonkAAB(_x, _y, _z, _xSize, _ySize, _zSize) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_AAB;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkAABCollideAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkAABCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkAABCollideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkAABCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkAABInsideAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkAABInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkAABInsideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkAABInsideSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    
    
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
    
    static GetAABB = function()
    {
        return {
            xMin: x - 0.5*xSize,
            yMin: y - 0.5*ySize,
            zMin: z - 0.5*zSize,
            xMax: x + 0.5*xSize,
            yMax: y + 0.5*ySize,
            zMax: z + 0.5*zSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggAABB(x, y, z, xSize, ySize, zSize, _color, _wireframe);
    }
}
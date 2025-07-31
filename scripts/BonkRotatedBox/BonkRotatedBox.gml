// Feather disable all

/// Constructor that generates an axis-aligned bounding box. Such a box cannot be rotated.
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
    
    static GetAABB = function()
    {
        //TODO - Do this properly
        return {
            x1: x - sqrt(2)*max(xSize, ySize),
            y1: y - sqrt(2)*max(xSize, ySize),
            z1: z - 0.5*zSize,
            x2: x + sqrt(2)*max(xSize, ySize),
            y2: y + sqrt(2)*max(xSize, ySize),
            z2: z + 0.5*zSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRotatedBox(x, y, z,   xSize, ySize, zSize,  zRotation,   _color, _wireframe);
    }
}
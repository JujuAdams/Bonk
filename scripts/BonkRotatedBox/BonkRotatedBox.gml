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
        //_array[@ BONK_TYPE_AABB    ] = BonkRotatedBoxCollideAABB;
        //_array[@ BONK_TYPE_OBB     ] = BonkRotatedBoxCollideRotatedBox;
        //_array[@ BONK_TYPE_CAPSULE ] = BonkRotatedBoxCollideCapsule;
        //_array[@ BONK_TYPE_CYLINDER] = BonkRotatedBoxCollideCylinder;
        //_array[@ BONK_TYPE_SPHERE  ] = BonkRotatedBoxCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        //_array[@ BONK_TYPE_AABB    ] = BonkRotatedBoxInsideAABB;
        //_array[@ BONK_TYPE_OBB     ] = BonkRotatedBoxInsideRotatedBox;
        //_array[@ BONK_TYPE_CAPSULE ] = BonkRotatedBoxInsideCapsule;
        //_array[@ BONK_TYPE_CYLINDER] = BonkRotatedBoxInsideCylinder;
        //_array[@ BONK_TYPE_SPHERE  ] = BonkRotatedBoxInsideSphere;
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
        var _cos =  dcos(zRotation);
        var _sin = -dsin(zRotation);
        
        var _w = xSize*_cos - ySize*_sin;
        var _h = xSize*_sin + ySize*_cos;
        
        return {
            x1: x - 0.5*_w,
            y1: y - 0.5*_h,
            z1: z - 0.5*zSize,
            x2: x + 0.5*_w,
            y2: y + 0.5*_h,
            z2: z + 0.5*zSize,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRotatedBox(x, y, z,   xSize, ySize, zSize,  zRotation,   _color, _wireframe);
    }
}
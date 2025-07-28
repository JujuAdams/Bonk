// Feather disable all

/// @param x
/// @param y
/// @param zCenter
/// @param height

function BonkPole(_x, _y, _z, _height) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_POLE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB    ] = BonkPoleCollideAABB;
        _array[@ BONK_TYPE_CYLINDER] = BonkPoleCollideCylinder;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB    ] = BonkPoleInsideAABB;
        _array[@ BONK_TYPE_CYLINDER] = BonkPoleInsideCylinder;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    height = _height;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            x1: x,
            y1: y,
            z1: z - 0.5*height,
            x2: x,
            y2: y,
            z2: z + 0.5*height,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggLine(x, y, z - 0.5*height, x, y, z + 0.5*height, _color, _wireframe);
    }
}
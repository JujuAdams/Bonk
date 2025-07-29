// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkWall(_x1, _y1, _z1, _x2, _y2, _z2) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_WALL;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        return _array;
    })();
    
    
    
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    
    
    static GetAABB = function()
    {
        return {
            x1: min(_x1, _x2),
            y1: min(_y1, _y2),
            z1: min(_z1, _z2),
            x2: max(_x1, _x2),
            y2: max(_y1, _y2),
            z2: max(_z1, _z2),
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggQuad(x1, y1, z1,   x2, y2, z1,   x1, y1, z2,   _color, _wireframe);
    }
}
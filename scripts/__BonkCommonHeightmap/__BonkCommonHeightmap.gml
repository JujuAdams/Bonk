// Feather disable all

function __BonkCommonHeightmap()
{
    bonkType = BONK_TYPE_HEIGHTMAP;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        return _array;
    })();
    
    static _touchFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        return _array;
    })();
    
    __bonkCollideFuncLookup = _collideFuncLookup;
    __bonkTouchFuncLookup  = _touchFuncLookup;
    
    LineHit = method(undefined, function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        static _nullHit = new BonkResultHit();
        //TODO
        return _nullHit;
    });
}
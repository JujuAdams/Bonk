// Feather disable all

function __BonkCommonQuad()
{
    bonkType = BONK_TYPE_QUAD;
    
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
    __bonkTouchFuncLookup   = _touchFuncLookup;
    __bonkLineHit           = BonkLineHitQuad;
    
    toString = method(undefined, function()
    {
        return $"<quad {x1}, {y1}, {z1} -> {x2}, {y2}, {z2} -> {x3}, {y3}, {z3}>";
    });
}
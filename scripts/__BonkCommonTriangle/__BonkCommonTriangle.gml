// Feather disable all

function __BonkCommonTriangle()
{
    bonkType = BONK_TYPE_TRIANGLE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkTriangleCollideCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkTriangleCollideSphere;
        _array[@ BONK_TYPE_WORLD  ] = BonkTriangleCollideWorld;
        return _array;
    })();
    
    static _touchFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkTriangleTouchCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkTriangleTouchSphere;
        _array[@ BONK_TYPE_WORLD  ] = BonkTriangleTouchWorld;
        return _array;
    })();
    
    __bonkCollideFuncLookup = _collideFuncLookup;
    __bonkTouchFuncLookup   = _touchFuncLookup;
    __bonkLineHit           = BonkLineHitTriangle;
    
    toString = method(undefined, function()
    {
        return $"<triangle {x1}, {y1}, {z1} -> {x2}, {y2}, {z2} -> {x3}, {y3}, {z3} / hardEdge {hardEdge12? "true" : "false"} : {hardEdge23? "true" : "false"} : {hardEdge31? "true" : "false"}>";
    });
}
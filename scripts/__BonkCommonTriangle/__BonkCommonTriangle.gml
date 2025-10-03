// Feather disable all

function __BonkCommonTriangle()
{
    bonkType = BONK_TYPE_TRIANGLE;
    __lineHitFunction = BonkLineHitTriangle;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkTriangleCollideCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkTriangleCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkTriangleTouchCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkTriangleTouchSphere;
        return _array;
    })();
    
    __collideFuncLookup = _collideFuncLookup;
    __insideFuncLookup  = _insideFuncLookup;
}
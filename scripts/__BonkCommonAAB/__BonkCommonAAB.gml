// Feather disable all

function __BonkCommonAAB()
{
    bonkType = BONK_TYPE_AAB;
    __lineHitFunction = BonkLineHitAAB;
    
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
        _array[@ BONK_TYPE_AAB     ] = BonkAABTouchAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkAABTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkAABTouchCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkAABTouchSphere;
        return _array;
    })();
    
    __collideFuncLookup = _collideFuncLookup;
    __insideFuncLookup  = _insideFuncLookup;
}
// Feather disable all

function __BonkCommonRotatedBox()
{
    bonkType = BONK_TYPE_OBB;
    __lineHitFunction = BonkLineHitRotatedBox;
    
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
        _array[@ BONK_TYPE_CAPSULE ] = BonkRotatedBoxTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkRotatedBoxTouchCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkRotatedBoxTouchSphere;
        return _array;
    })();
    
    __collideFuncLookup = _collideFuncLookup;
    __insideFuncLookup  = _insideFuncLookup;
}
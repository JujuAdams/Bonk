// Feather disable all

function __BonkCommonCylinder()
{
    bonkType = BONK_TYPE_CYLINDER;
    __lineHitFunction = BonkLineHitCylinder;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCylinderCollideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkCylinderCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCylinderCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCylinderCollideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCylinderCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCylinderTouchAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkCylinderTouchRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCylinderTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCylinderTouchCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCylinderTouchSphere;
        return _array;
    })();
    
    __collideFuncLookup = _collideFuncLookup;
    __insideFuncLookup  = _insideFuncLookup;
}
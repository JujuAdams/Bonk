// Feather disable all

function __BonkCommonAAB()
{
    bonkType = BONK_TYPE_AAB;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB      ] = BonkAABCollideAAB;
        _array[@ BONK_TYPE_CAPSULE  ] = BonkAABCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER ] = BonkAABCollideCylinder;
        _array[@ BONK_TYPE_SPHERE   ] = BonkAABCollideSphere;
        _array[@ BONK_TYPE_WORLD    ] = BonkAABCollideWorld;
        _array[@ BONK_TYPE_HEIGHTMAP] = BonkAABCollideHeightmap;
        return _array;
    })();
    
    static _touchFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB      ] = BonkAABTouchAAB;
        _array[@ BONK_TYPE_CAPSULE  ] = BonkAABTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER ] = BonkAABTouchCylinder;
        _array[@ BONK_TYPE_SPHERE   ] = BonkAABTouchSphere;
        _array[@ BONK_TYPE_WORLD    ] = BonkAABTouchWorld;
        _array[@ BONK_TYPE_HEIGHTMAP] = BonkAABTouchHeightmap;
        return _array;
    })();
    
    __bonkCollideFuncLookup = _collideFuncLookup;
    __bonkTouchFuncLookup   = _touchFuncLookup;
    __bonkLineHit           = BonkLineHitAAB;
    
    toString = method(undefined, function()
    {
        return $"<aab {x}, {y}, {z} / size {xSize} {ySize} {zSize}>";
    });
}
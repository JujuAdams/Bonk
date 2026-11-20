// Feather disable all

function __BonkCommonCapsule()
{
    bonkType = BONK_TYPE_CAPSULE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB      ] = BonkCapsuleCollideAAB;
        _array[@ BONK_TYPE_OBB      ] = BonkCapsuleCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE  ] = BonkCapsuleCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER ] = BonkCapsuleCollideCylinder;
        _array[@ BONK_TYPE_QUAD     ] = BonkCapsuleCollideQuad;
        _array[@ BONK_TYPE_SPHERE   ] = BonkCapsuleCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE ] = BonkCapsuleCollideTriangle;
        _array[@ BONK_TYPE_WORLD    ] = BonkCapsuleCollideWorld;
        _array[@ BONK_TYPE_MESH     ] = BonkCapsuleCollideMesh;
        _array[@ BONK_TYPE_HEIGHTMAP] = BonkCapsuleCollideHeightmap;
        return _array;
    })();
    
    static _touchFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB      ] = BonkCapsuleTouchAAB;
        _array[@ BONK_TYPE_OBB      ] = BonkCapsuleTouchRotatedBox;
        _array[@ BONK_TYPE_CAPSULE  ] = BonkCapsuleTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER ] = BonkCapsuleTouchCylinder;
        _array[@ BONK_TYPE_QUAD     ] = BonkCapsuleTouchQuad;
        _array[@ BONK_TYPE_SPHERE   ] = BonkCapsuleTouchSphere;
        _array[@ BONK_TYPE_TRIANGLE ] = BonkCapsuleTouchTriangle;
        _array[@ BONK_TYPE_WORLD    ] = BonkCapsuleTouchWorld;
        _array[@ BONK_TYPE_MESH     ] = BonkCapsuleTouchMesh;
        _array[@ BONK_TYPE_HEIGHTMAP] = BonkCapsuleTouchHeightmap;
        return _array;
    })();
    
    __bonkCollideFuncLookup = _collideFuncLookup;
    __bonkTouchFuncLookup   = _touchFuncLookup;
    __bonkLineHit           = BonkLineHitCapsule;
    
    toString = method(undefined, function()
    {
        return $"<capsule {x}, {y}, {z} / height {height} / radius {radius}>";
    });
}
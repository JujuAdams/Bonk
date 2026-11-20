// Feather disable all

function __BonkCommonSphere()
{
    bonkType = BONK_TYPE_SPHERE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB      ] = BonkSphereCollideAAB;
        _array[@ BONK_TYPE_OBB      ] = BonkSphereCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE  ] = BonkSphereCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER ] = BonkSphereCollideCylinder;
        _array[@ BONK_TYPE_QUAD     ] = BonkSphereCollideQuad;
        _array[@ BONK_TYPE_SPHERE   ] = BonkSphereCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE ] = BonkSphereCollideTriangle;
        _array[@ BONK_TYPE_WORLD    ] = BonkSphereCollideWorld;
        _array[@ BONK_TYPE_MESH     ] = BonkSphereCollideMesh;
        _array[@ BONK_TYPE_HEIGHTMAP] = BonkSphereCollideHeightmap;
        return _array;
    })();
    
    static _touchFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB      ] = BonkSphereTouchAAB;
        _array[@ BONK_TYPE_OBB      ] = BonkSphereTouchRotatedBox;
        _array[@ BONK_TYPE_CAPSULE  ] = BonkSphereTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER ] = BonkSphereTouchCylinder;
        _array[@ BONK_TYPE_QUAD     ] = BonkSphereTouchQuad;
        _array[@ BONK_TYPE_SPHERE   ] = BonkSphereTouchSphere;
        _array[@ BONK_TYPE_TRIANGLE ] = BonkSphereTouchTriangle;
        _array[@ BONK_TYPE_WORLD    ] = BonkSphereTouchWorld;
        _array[@ BONK_TYPE_MESH     ] = BonkSphereTouchMesh;
        _array[@ BONK_TYPE_HEIGHTMAP] = BonkSphereTouchHeightmap;
        return _array;
    })();
    
    __bonkCollideFuncLookup = _collideFuncLookup;
    __bonkTouchFuncLookup   = _touchFuncLookup;
    __bonkLineHit           = BonkLineHitSphere;
    
    toString = method(undefined, function()
    {
        return $"<sphere {x}, {y}, {z} / radius {radius}>";
    });
}
// Feather disable all

function __BonkCommonSphere()
{
    bonkType = BONK_TYPE_SPHERE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkSphereCollideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkSphereCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkSphereCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkSphereCollideCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkSphereCollideQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkSphereCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkSphereCollideTriangle;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkSphereTouchAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkSphereTouchRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkSphereTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkSphereTouchCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkSphereTouchQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkSphereTouchSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkSphereTouchTriangle;
        return _array;
    })();
    
    __collideFuncLookup = _collideFuncLookup;
    __insideFuncLookup  = _insideFuncLookup;
    
    LineHit = method(undefined, function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        static _nullHit = new BonkResultHit();
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            return BonkLineHitSphere(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct);
        }
        else
        {
            return (_struct == undefined)? _nullHit : _struct.__Null();
        }
    });
}
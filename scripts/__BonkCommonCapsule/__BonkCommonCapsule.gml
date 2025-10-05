// Feather disable all

function __BonkCommonCapsule()
{
    bonkType = BONK_TYPE_CAPSULE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCapsuleCollideAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkCapsuleCollideRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCapsuleCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCapsuleCollideCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkCapsuleCollideQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCapsuleCollideSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkCapsuleCollideTriangle;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkCapsuleTouchAAB;
        _array[@ BONK_TYPE_OBB     ] = BonkCapsuleTouchRotatedBox;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCapsuleTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkCapsuleTouchCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkCapsuleTouchQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkCapsuleTouchSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkCapsuleTouchTriangle;
        return _array;
    })();
    
    __collideFuncLookup = _collideFuncLookup;
    __insideFuncLookup  = _insideFuncLookup;
    
    LineHit = method(undefined, function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1)
    {
        static _nullHit = __Bonk().__nullHit;
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            return BonkLineHitCapsule(self, _x1, _y1, _z1, _x2, _y2, _z2);
        }
        else
        {
            return _nullHit;
        }
    });
}
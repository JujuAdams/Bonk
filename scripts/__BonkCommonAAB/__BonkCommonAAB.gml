// Feather disable all

function __BonkCommonAAB()
{
    bonkType = BONK_TYPE_AAB;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkAABCollideAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkAABCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkAABCollideCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkAABCollideSphere;
        return _array;
    })();
    
    static _touchFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkAABTouchAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkAABTouchCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkAABTouchCylinder;
        _array[@ BONK_TYPE_SPHERE  ] = BonkAABTouchSphere;
        return _array;
    })();
    
    __bonkCollideFuncLookup = _collideFuncLookup;
    __bonkTouchFuncLookup   = _touchFuncLookup;
    
    LineHit = method(undefined, function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        static _nullHit = new BonkResultHit();
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            return BonkLineHitAAB(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct);
        }
        else
        {
            return (_struct == undefined)? _nullHit : _struct.__Null();
        }
    });
}
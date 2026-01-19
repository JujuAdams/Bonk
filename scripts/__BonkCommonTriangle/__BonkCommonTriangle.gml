// Feather disable all

function __BonkCommonTriangle()
{
    bonkType = BONK_TYPE_TRIANGLE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkTriangleCollideCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkTriangleCollideSphere;
        return _array;
    })();
    
    static _touchFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkTriangleTouchCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkTriangleTouchSphere;
        _array[@ BONK_TYPE_WORLD  ] = BonkTriangleTouchWorld;
        return _array;
    })();
    
    __bonkCollideFuncLookup = _collideFuncLookup;
    __bonkTouchFuncLookup  = _touchFuncLookup;
    
    LineHit = method(undefined, function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        static _nullHit = new BonkResultHit();
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            return BonkLineHitTriangle(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct);
        }
        else
        {
            return (_struct == undefined)? _nullHit : _struct.__Null();
        }
    });
}
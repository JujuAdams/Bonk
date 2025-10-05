// Feather disable all

function __BonkCommonRotatedBox()
{
    bonkType = BONK_TYPE_OBB;
    
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
    
    LineHit = method(undefined, function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1)
    {
        static _nullHit = __Bonk().__nullHit;
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            return BonkLineHitRotatedBox(self, _x1, _y1, _z1, _x2, _y2, _z2);
        }
        else
        {
            return _nullHit;
        }
    });
}
// Feather disable all

function __BonkCommonCylinder()
{
    bonkType = BONK_TYPE_CYLINDER;
    
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
    
    LineHit = method(undefined, function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        static _nullHit = new __BonkClassHit();
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            return BonkLineHitCylinder(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct);
        }
        else
        {
            return (_struct == undefined)? _nullHit : _struct.__Null();
        }
    });
}
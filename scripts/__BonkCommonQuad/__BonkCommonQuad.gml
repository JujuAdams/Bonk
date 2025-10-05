// Feather disable all

function __BonkCommonQuad()
{
    bonkType = BONK_TYPE_QUAD;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkQuadCollideCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkQuadCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE] = BonkQuadTouchCapsule;
        _array[@ BONK_TYPE_SPHERE ] = BonkQuadTouchSphere;
        return _array;
    })();
    
    __collideFuncLookup = _collideFuncLookup;
    __insideFuncLookup  = _insideFuncLookup;
    
    LineHit = method(undefined, function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        static _nullHit = __Bonk().__nullHit;
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            return BonkLineHitQuad(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct);
        }
        else
        {
            return (_struct == undefined)? _nullHit : _struct.__Null();
        }
    });
}
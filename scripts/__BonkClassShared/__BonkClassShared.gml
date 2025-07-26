// Feather disable all

/// @param x
/// @param y
/// @param z

function __BonkClassShared(_x, _y, _z) constructor
{
    static _collideFuncLookup = __Bonk().__collideFuncLookup;
    
    x = _x;
    y = _y;
    z = _z;
    
    
    
    static Collide = function(_otherPrimitive)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        var _collideFunc = _collideFuncLookup[bonkType][_otherPrimitive.bonkType];
        if (is_callable(_collideFunc))
        {
            return _collideFunc(self, _otherPrimitive);
        }
        else
        {
            if (BONK_STRICT_COLLISION_COMPATIBILITY)
            {
                __BonkError($"Collision not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherPrimitive)}\" (type={_otherPrimitive.bonkType})");
            }
        }
        
        return _nullReaction;
    }
}
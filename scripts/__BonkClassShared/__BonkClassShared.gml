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
    
    
    
    static Collide = function(_otherShape)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        var _collideFunc = _collideFuncLookup[bonkType][_otherShape.bonkType];
        if (is_callable(_collideFunc))
        {
            return _collideFunc(self, _otherShape);
        }
        else
        {
            if (BONK_STRICT_COLLISION_COMPATIBILITY)
            {
                __BonkError($".Collide() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return _nullReaction;
    }
}
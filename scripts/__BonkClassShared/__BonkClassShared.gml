// Feather disable all

function __BonkClassShared() constructor
{
    static Inside = function(_otherShape)
    {
        var _insideFunc = _insideFuncLookup[_otherShape.bonkType];
        if (is_callable(_insideFunc))
        {
            return _insideFunc(self, _otherShape);
        }
        else
        {
            if (BONK_STRICT_COLLISION_COMPATIBILITY)
            {
                __BonkError($".Inside() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return false;
    }
    
    static Collide = function(_otherShape)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        var _collideFunc = _collideFuncLookup[_otherShape.bonkType];
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
    
    static Hit = function(_otherShape)
    {
        static _nullHit = __Bonk().__nullHit;
        
        if (BONK_STRICT_COLLISION_COMPATIBILITY)
        {
            __BonkError($".Hit() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
        }
        
        return _nullHit;
    }
}
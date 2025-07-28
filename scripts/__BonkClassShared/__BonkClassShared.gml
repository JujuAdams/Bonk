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
    
    static PushOut = function(_subjectShape, _slopeThreshold = 36)
    {
        with(_subjectShape)
        {
            var _reaction = Collide(other);
            if (_reaction.collision)
            {
                var _dX = _reaction.dX;
                var _dY = _reaction.dY;
                var _dZ = _reaction.dZ;
                
                var _distance = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
                if ((_dZ / _distance) > clamp(dcos(_slopeThreshold), 0, 1))
                {
                    //If the slope is shallow enough, just move upwards
                    //This movement is approximate but good enough
                    z += _distance;
                }
                else
                {
                    //Otherwise move out as per normal which will typically slide the subject down slopes
                    x += _dX;
                    y += _dY;
                    z += _dZ;
                }
            }
        }
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
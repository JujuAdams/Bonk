// Feather disable all

/// @param groupVector

function __BonkClassShared(_groupVector) constructor
{
    if (BONK_DEBUG_STRUCTS)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_pop(bonkCreateCallstack);
    }
    
    __bonkWorld = undefined;
    bonkGroup = _groupVector;
    
    
    
    static AddPosition = function(_dX, _dY, _dZ)
    {
        SetPosition(x + _dX, y + _dY, z + _dZ);
    }
    
    static RemoveFromWorld = function()
    {
        if (__bonkWorld != undefined)
        {
            __bonkWorld.__RemoveShape(self);
            SetPosition = __SetPositionFree;
        }
    }
    
    static Touch = function(_otherShape, _groupFilter = undefined, _quietFail = false)
    {
        if (BonkFilterTest(bonkGroup, _groupFilter))
        {
            return false;
        }
        
        var _insideFunc = __bonkTouchFuncLookup[_otherShape.bonkType];
        if (is_callable(_insideFunc))
        {
            return _insideFunc(self, _otherShape);
        }
        else
        {
            if (BONK_STRICT)
            {
                __BonkConditionalError(not _quietFail, $".Touch() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return false;
    }
    
    static Collide = function(_otherShape, _groupFilter = undefined, _struct = undefined, _quietFail = false)
    {
        static _nullCollisionData = new BonkResultCollide();
        
        if (BonkFilterTest(bonkGroup, _groupFilter))
        {
            var _collideFunc = __bonkCollideFuncLookup[_otherShape.bonkType];
            if (is_callable(_collideFunc))
            {
                return _collideFunc(self, _otherShape, _struct);
            }
            else
            {
                if (BONK_STRICT)
                {
                    __BonkConditionalError(not _quietFail, $".Collide() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
                }
            }
        }
        
        return (_struct == undefined)? _nullCollisionData : _struct.Null();
    }
    
    static LineHit = function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = undefined, _struct = undefined)
    {
        static _nullHit = new BonkResultHit();
        
        if (BonkFilterTest(bonkGroup, _groupFilter))
        {
            return __bonkLineHit(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct);
        }
        else
        {
            return (_struct == undefined)? _nullHit : _struct.Null();
        }
    }
    
    static __CollideAddToArray = function(_collideArrayContainer, _otherShape, _groupFilter)
    {
        var _collide = _otherShape.Collide(self, _groupFilter, _collideArrayContainer.__collideArray[_collideArrayContainer.__count], true);
        
        if (_collide.shape != undefined)
        {
            ++_collideArrayContainer.__count;
            return _collide;
        }
        else
        {
            return undefined;
        }
    }
    
    static Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = undefined)
    {
        return __BonkConvertCollideToDeflect(_subjectShape, _slopeThreshold, _subjectShape.Collide(self, _groupFilter));
    }
}
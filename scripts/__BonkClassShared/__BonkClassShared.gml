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
    
    static FilterTest = function(_filter)
    {
        if (_filter < 0)
        {
            return true;
        }
        
        var _bonkGroup = bonkGroup;
        
        //Filter out shapes that conflict with the NOT vector (if in use)
        var _notVector = (_filter >> 40) & 0xFFFFF;
        if ((_notVector > 0) && (_bonkGroup & _notVector))
        {
            return false;
        }
        
        //Accept shapes that hit the OR vector
        if (_bonkGroup & (_filter & 0xFFFFF))
        {
            return true;
        }
        
        //Accept shapes the hit all of the AND vector (if in use)
        var _andVector = (_filter >> 20) & 0xFFFFF;
        if ((_andVector > 0) && ((_bonkGroup & _andVector) == _andVector))
        {
            return true;
        }
        
        return false;
    }
    
    static Touch = function(_otherShape, _groupFilter = -1, _quietFail = false)
    {
        if ((_groupFilter >= 0) && (not FilterTest(_groupFilter)))
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
    
    static Collide = function(_otherShape, _groupFilter = -1, _struct = undefined, _quietFail = false)
    {
        static _nullCollisionData = new BonkResultCollide();
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
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
    
    static __CollideForDeflect = function(_array, _otherShape, _groupFilter = -1)
    {
        static _staticCollideStruct = new BonkResultCollide();
        
        var _collide = _otherShape.Collide(self, _groupFilter, _staticCollideStruct, true);
        if (_collide.shape != undefined)
        {
            array_push(_array, _collide);
            _staticCollideStruct = new BonkResultCollide();
        }
    }
    
    static Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = -1)
    {
        return __BonkConvertCollideToDeflect(_subjectShape, _slopeThreshold, _subjectShape.Collide(self, _groupFilter));
    }
}
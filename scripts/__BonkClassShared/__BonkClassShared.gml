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
    
    static Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = -1, _struct = undefined)
    {
        static _staticDeflect = new BonkResultDeflect();
        var _reaction = _struct ?? _staticDeflect;
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            with(_subjectShape)
            {
                var _collisionData = Collide(other, undefined, _reaction.collisionData);
                if (_collisionData.shape != undefined)
                {
                    var _dX = _collisionData.dX;
                    var _dY = _collisionData.dY;
                    var _dZ = _collisionData.dZ;
                    
                    var _distance = max(0.00001, sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ));
                    if ((_dZ / _distance) > clamp(dcos(_slopeThreshold), 0, 1))
                    {
                        //If the slope is shallow enough, just move upwards
                        //This movement is approximate but good enough
                        AddPosition(0, 0, _distance);
                        _reaction.deflectType = BONK_DEFLECT_GRIPPY;
                    }
                    else
                    {
                        //Otherwise move out as usual which will typically slide the subject down slopes
                        AddPosition(_dX, _dY, _dZ);
                        _reaction.deflectType = BONK_DEFLECT_SLIPPERY;
                    }
                }
                else
                {
                    //No collision
                    _reaction.deflectType = BONK_DEFLECT_NONE;
                }
                
                return _reaction;
            }
        }
        
        return _reaction.__Null();
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
        
        return (_struct == undefined)? _nullCollisionData : _struct.__Null();
    }
}
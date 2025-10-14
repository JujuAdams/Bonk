// Feather disable all

function __BonkCommonInstanceFunctions(_groupVector = BONK_DEFAULT_GROUP)
{
    if (BONK_DEBUG_INSTANCES)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_shift(bonkCreateCallstack);
        array_pop(bonkCreateCallstack);
    }
    
    bonkGroup = _groupVector;
    
    
    
    SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        if (BONK_SET_INSTANCE_DEPTH)
        {
            depth = _z;
        }
        
        return self;
    }
    
    RemoveFromWorld = function() {} //Do nothing!
    
    AddPosition = function(_dX, _dY, _dZ)
    {
        SetPosition(x + _dX, y + _dY, z + _dZ);
    }
    
    FilterTest = function(_filter = -1)
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

    Touch = function(_otherShape, _groupFilter = -1)
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
                __BonkError($".Touch() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
    
        return false;
    }
    
    Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = -1, _struct = undefined)
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
                
                _reaction.collisionData = _collisionData;
                return _reaction;
            }
        }
        
        return _reaction.__Null();
    }
    
    Collide = function(_otherShape, _groupFilter = -1, _struct = undefined)
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
                    __BonkError($".Collide() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
                }
            }
        }
    
        return (_struct == undefined)? _nullCollisionData : _struct.__Null();
    }
    
    DebugDrawMask = function(_color = c_white)
    {
        draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, _color, 1);
    }
}
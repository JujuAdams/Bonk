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
    
    Touch = function(_otherShape, _groupFilter = undefined, _quietFail = false)
    {
        if (BonkFilterTest(bonkGroup, _groupFilter))
        {
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
        }
    
        return false;
    }
    
    Collide = function(_otherShape, _groupFilter = undefined, _struct = undefined, _quietFail = false)
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
    
    LineHit = function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = undefined, _struct = undefined)
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
    
    __CollideAddToArray = function(_collideArrayContainer, _otherShape, _groupFilter)
    {
        var _collide = _otherShape.Collide(self, _groupFilter, _collideArrayContainer.__collideArray[_collideArrayContainer.__count], true);
        if (_collide.shape != undefined)
        {
            ++_collideArrayContainer.__count;
        }
    }
    
    Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = undefined)
    {
        return __BonkConvertCollideToDeflect(_subjectShape, _slopeThreshold, _subjectShape.Collide(self, _groupFilter));
    }
    
    DebugDrawMask = function(_color = c_white)
    {
        draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, _color, 1);
    }
}
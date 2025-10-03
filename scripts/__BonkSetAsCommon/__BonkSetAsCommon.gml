// Feather disable all

function __BonkSetAsCommon()
{
    if (BONK_DEBUG_INSTANCES)
    {
        __bonkOrigin = debug_get_callstack();
        array_shift(__bonkOrigin);
        array_pop(__bonkOrigin);
    }
    
    CleanUp = function()
    {
        if (BONK_INSTANCE_XZ)
        {
            instance_destroy(__instanceXZ);
        }
    }
    
    AddPosition = function(_dX, _dY, _dZ)
    {
        SetPosition(x + _dX, y + _dY, z + _dZ);
    }

    Touch = function(_otherShape)
    {
        var _insideFunc = __insideFuncLookup[_otherShape.bonkType];
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
    
    PushOut = function(_subjectShape, _slopeThreshold = 0)
    {
        static _reaction = new __BonkClassPushOutReaction();
        static _nullCollisionReaction = __Bonk().__nullCollisionReaction;
    
        _reaction.targetShape = self;
    
        with(_subjectShape)
        {
            var _collisionReaction = Collide(other);
            if (_collisionReaction.collision)
            {
                var _dX = _collisionReaction.dX;
                var _dY = _collisionReaction.dY;
                var _dZ = _collisionReaction.dZ;
            
                var _distance = max(0.00001, sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ));
                if ((_dZ / _distance) > clamp(dcos(_slopeThreshold), 0, 1))
                {
                    //If the slope is shallow enough, just move upwards
                    //This movement is approximate but good enough
                    z += _distance;
                
                    _reaction.pushOutType = BONK_PUSH_OUT_GRIPPY;
                }
                else
                {
                    //Otherwise move out as usual which will typically slide the subject down slopes
                    x += _dX;
                    y += _dY;
                    z += _dZ;
                
                    _reaction.pushOutType = BONK_PUSH_OUT_SLIPPERY;
                }
            }
            else
            {
                //No collision
                _reaction.pushOutType = BONK_PUSH_OUT_NONE;
            }
        
            _reaction.collisionReaction = _collisionReaction;
        
            return _reaction;
        }
    
        //Subject shape was `undefined`
        _reaction.collisionReaction = _nullCollisionReaction;
        _reaction.pushOutType       = BONK_PUSH_OUT_NONE;
    
        return _reaction;
    }
    
    Collide = function(_otherShape)
    {
        static _nullCollisionReaction = __Bonk().__nullCollisionReaction;
    
        var _collideFunc = __collideFuncLookup[_otherShape.bonkType];
        if (is_callable(_collideFunc))
        {
            return _collideFunc(self, _otherShape);
        }
        else
        {
            if (BONK_STRICT)
            {
                __BonkError($".Collide() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
    
        return _nullCollisionReaction;
    }

    DrawXY = function(_color = c_white)
    {
        draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, _color, 1);
    }

    DrawXZ = function(_color = c_white)
    {
        if (BONK_INSTANCE_XZ)
        {
            with(__instanceXZ)
            {
                draw_sprite_ext(mask_index, 0, x, -y, image_xscale, image_yscale, image_angle, _color, 1);
            }
        }
    }
}
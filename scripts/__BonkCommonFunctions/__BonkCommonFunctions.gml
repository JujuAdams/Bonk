// Feather disable all

function __BonkCommonFunctions()
{
    if (BONK_DEBUG_INSTANCES)
    {
        __bonkOrigin = debug_get_callstack();
        array_shift(__bonkOrigin);
        array_pop(__bonkOrigin);
    }
    
    bonkGroup = 0x00;
    
    
    
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
    
    AddVelocity = function(_velocityStruct)
    {
        SetPosition(x + _velocityStruct.xSpeed, y + _velocityStruct.ySpeed, z + _velocityStruct.zSpeed);
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
    
    Deflect = function(_subjectShape, _slopeThreshold = 0)
    {
        static _reaction = new __BonkClassDeflectData();
        static _nullCollisionData = __Bonk().__nullCollisionData;
    
        _reaction.targetShape = self;
    
        with(_subjectShape)
        {
            var _collisionData = Collide(other);
            if (_collisionData.collision)
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
    
        //Subject shape was `undefined`
        _reaction.collisionData = _nullCollisionData;
        _reaction.deflectType   = BONK_DEFLECT_NONE;
    
        return _reaction;
    }
    
    Collide = function(_otherShape)
    {
        static _nullCollisionData = __Bonk().__nullCollisionData;
    
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
    
        return _nullCollisionData;
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
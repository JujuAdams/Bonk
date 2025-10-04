// Feather disable all

function __BonkClassShared() constructor
{
    __world = undefined;
    
    
    
    static AddPosition = function(_dX, _dY, _dZ)
    {
        SetPosition(x + _dX, y + _dY, z + _dZ);
    }
    
    static AddVelocity = function(_velocityStruct)
    {
        SetPosition(x + _velocityStruct.xSpeed, y + _velocityStruct.ySpeed, z + _velocityStruct.zSpeed);
    }
    
    static FilterTest = function(_filter)
    {
        var _andVector = (_filter >> 20) & 0xFFFFF;
        var _norVector = (_filter >> 40) & 0xFFFFF;
        
        var _orVector = _filter & 0xFFFFF;
        return (((bonkGroup & (_filter & 0xFFFFF))
             || ((bonkGroup & _andVector) == _andVector))
            && (not (bonkGroup & _norVector)))
    }
    
    static Touch = function(_otherShape)
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
    
    static Deflect = function(_subjectShape, _slopeThreshold = 0)
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
                    z += _distance;
                    
                    _reaction.deflectType = BONK_DEFLECT_GRIPPY;
                }
                else
                {
                    //Otherwise move out as usual which will typically slide the subject down slopes
                    x += _dX;
                    y += _dY;
                    z += _dZ;
                    
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
        _reaction.deflectType       = BONK_DEFLECT_NONE;
        
        return _reaction;
    }
    
    static Collide = function(_otherShape)
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
    
    static CollisionList = function(_dX, _dY, _dZ, _groupFilter = undefined, _list = undefined, _object = BonkObject)
    {
        return BonkInstancePlaceList(self, _dX, _dY, _dZ, _groupFilter, _list, _object);
    }
}
function BonkSphere() constructor
{
    static __bonkType = __BONK_TYPE.SPHERE;
    
    static toString = function()
    {
        return "sphere";
    }
    
    
    
    #region Setters / Getters
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        if ((x != _x) || (y != _y) || (z != _z))
        {
            xPrevious = x;
            yPrevious = y;
            zPrevious = z;
            
            x = _x;
            y = _y;
            z = _z;
        }
        
        return self;
    }
    
    static SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        return self;
    }
    
    static GetPosition = function()
    {
        return {
            x: x,
            y: y,
            z: z,
        };
    }
    
    static GetRadius = function()
    {
        return radius;
    }
    
    static GetAABB = function()
    {
        return {
            x1: x - radius,
            y1: y - radius,
            z1: z - radius,
            x2: x + radius,
            y2: y + radius,
            z2: z + radius,
        };
    }
    
    #endregion
    
    
    
    #region Variables
    
    x = 0;
    y = 0;
    z = 0;
    
    xPrevious = 0;
    yPrevious = 0;
    zPrevious = 0;
    
    radius = 0;
    
    #endregion
    
    
    
    #region Draw
    
    static Draw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        __BonkDrawSphere(x, y, z, radius, _color);
    }
    
    #endregion
    
    
    
    #region General Collision Handler
    
    static Collision = function(_other)
    {
        return __BonkSharedCollisionHandler(_other);
    }
    
    #endregion
    
    
    
    #region Specific Collisions
    
    static __CollisionWithPoint = function(_other)
    {
        return _other.__CollisionWithSphere(self).__Invert();
    }
    
    static __CollisionWithSphere = function(_other)
    {
        var _radius_other = _other.radius;
        
        var _directionX = x - _other.x;
        var _directionY = y - _other.y;
        var _directionZ = z - _other.z;
        
        var _length = sqrt(_directionX*_directionX + _directionY*_directionY + _directionZ*_directionZ);
        
        //Special case where the sphere centres overlap perfectly
        if (_length == 0)
        {
            //Give the normal as the direction to the previous point
            var _directionX = x - xPrevious;
            var _directionY = y - yPrevious;
            var _directionZ = z - zPrevious;
            
            var _inverseLength = 1/_length;
            _directionX *= _inverseLength;
            _directionY *= _inverseLength;
            _directionZ *= _inverseLength;
            
            return new BonkResult(_directionX, _directionY, _directionZ, radius + _radius_other);
        }
        
        //Early out if the point is fully outside the sphere
    	if (_length >= radius + _radius_other) return new BonkResult();
        
        var _inverseLength = 1/_length;
        _directionX *= _inverseLength;
        _directionY *= _inverseLength;
        _directionZ *= _inverseLength;
        
        return new BonkResult(_directionX, _directionY, _directionZ, radius + _radius_other - _length);
    }
    
    #endregion
}
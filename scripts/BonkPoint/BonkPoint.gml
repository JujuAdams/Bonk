function BonkPoint() constructor
{
    static __bonkType = __BONK_TYPE.POINT;
    
    static toString = function()
    {
        return "point";
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
    
    static GetPosition = function()
    {
        return {
            x: x,
            y: y,
            z: z,
        };
    }
    
    static GetAABB = function()
    {
        return {
            x1: x,
            y1: y,
            z1: z,
            x2: x,
            y2: y,
            z2: z,
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
    
    #endregion
    
    
    
    #region Draw
    
    static Draw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawPoint(x, y, z, _color);
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
        if ((x == _other.x) && (y == _other.y) && (z == _other.z))
        {
            var _normalX = xPrevious - x;
            var _normalY = yPrevious - y;
            var _normalZ = zPrevious - z;
            
            var _inverseLength = 1/sqrt(_normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ);
            _normalX *= _inverseLength;
            _normalY *= _inverseLength;
            _normalZ *= _inverseLength;
            
            return new BonkResult(x, y, z,
                                  _normalX, _normalY, _normalZ,
                                  BONK_MINIMUM_COLLISION_DEPTH);
        }
        else
        {
            return new BonkResult();
        }
    }
    
    static __CollisionWithSphere = function(_sphere)
    {
        if (keyboard_check_pressed(ord("J")))
        {
            show_debug_message("!");
        }
        
        var _directionX = x - _sphere.x;
        var _directionY = y - _sphere.y;
        var _directionZ = z - _sphere.z;
        
        var _squareLength = _directionX*_directionX + _directionY*_directionY + _directionZ*_directionZ;
        
        //Special case where a point is right in the middle of a sphere
        if (_squareLength == 0)
        {
            //Give the normal as the direction to the previous point
            var _directionX = x - xPrevious;
            var _directionY = y - yPrevious;
            var _directionZ = z - zPrevious;
            
            var _inverseLength = 1/_length;
            _directionX *= _inverseLength;
            _directionY *= _inverseLength;
            _directionZ *= _inverseLength;
            
            return new BonkResult(_directionX, _directionY, _directionZ, _radius);
        }
        
        //Early out if the point is fully outside the sphere
        var _radius = _sphere.radius;
        if (_squareLength >= _radius*_radius) return new BonkResult();
        
        var _length = sqrt(_squareLength);
        
        var _inverseLength = 1/_length;
        _directionX *= _inverseLength;
        _directionY *= _inverseLength;
        _directionZ *= _inverseLength;
        
        return new BonkResult(_directionX, _directionY, _directionZ, _radius - _length);
    }
    
    static __CollisionWithRay = function(_other)
    {
        return _other.__CollisionWithRay(self).__Invert();
    }
    
    #endregion
}
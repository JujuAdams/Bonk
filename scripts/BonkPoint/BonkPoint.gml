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
    
    
    
    #region Debug Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
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
    
    static __CollisionWithAABB = function(_aabb)
    {
        var _position = [x, y, z];
        
        with(_aabb)
        {
            var _aabb_centre    = [x, y, z];
            var _aabb_half_dims = [xHalfSize, yHalfSize, zHalfSize];
        }

        var _aabb_min = BonkVecSubtract(_aabb_centre, _aabb_half_dims);
        var _aabb_max = BonkVecAdd(     _aabb_centre, _aabb_half_dims);

        if (!__BonkAABBPointInsideMinMax(_position, _aabb_min, _aabb_max)) return new BonkResult();

        var _local_position = BonkVecSubtract(_position, _aabb_centre);
        var _k = BonkVecSubtract(_aabb_half_dims, BonkVecAbs(_local_position));

        if ((_k[0] < _k[1]) && (_k[0] < _k[2]))
        {
            var _sign = sign(_local_position[0]);
            return new BonkResult(_sign, 0, 0, abs(_local_position[0]));
        }
        else if ((_k[1] < _k[0]) && (_k[1] < _k[2]))
        {
            var _sign = sign(_local_position[1]);
            return new BonkResult(0, _sign, 0, abs(_local_position[1]));
        }

        var _sign = sign(_local_position[2]);
        return new BonkResult(0, 0, _sign, abs(_local_position[2]));
    }
    
    static __CollisionWithPlane = function(_plane)
    {
        with(_plane)
        {
            var _plane_point    = [x, y, z];
            var _plane_normal   = [xNormal, yNormal, zNormal];
            var _plane_distance = BonkVecDot(_plane_point, _plane_normal); //TODO - Optimise this!
        }
        
        var _distance = BonkVecDot([x, y, z], _plane_normal) - _plane_distance;
        if (_distance > 0) return new BonkResult();
        
        //var _point = BonkVecSubtract(_point, BonkVecMultiply(_plane_normal, _distance));
        return new BonkResult(_plane_normal[0], _plane_normal[1], _plane_normal[2]);
        //return [ _plane[0], _plane[1], _plane[2],
        //         _point[0], _point[1], _point[2] ];
    }
    
    #endregion
}
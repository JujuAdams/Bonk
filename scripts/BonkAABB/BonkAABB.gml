function BonkAABB() constructor
{
    static __bonkType = __BONK_TYPE.AABB;
    
    static toString = function()
    {
        return "point";
    }
    
    
    
    #region Setters / Getters
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetSize = function(_x = 2*xHalfSize, _y = 2*yHalfSize, _z = 2*zHalfSize)
    {
        xHalfSize = 0.5*_x;
        yHalfSize = 0.5*_y;
        zHalfSize = 0.5*_z;
        
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
    
    static GetSize = function()
    {
        return {
            x: 2*xHalfSize,
            y: 2*yHalfSize,
            z: 2*zHalfSize,
        };
    }
    
    static GetAABB = function()
    {
        return {
            x1: x - xHalfSize,
            y1: y - yHalfSize,
            z1: z - zHalfSize,
            x2: x + xHalfSize,
            y2: y + yHalfSize,
            z2: z + zHalfSize,
        };
    }
    
    #endregion
    
    
    
    #region Variables
    
    x = 0;
    y = 0;
    z = 0;
    
    xHalfSize = 0;
    yHalfSize = 0;
    zHalfSize = 0;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawAABB(x - xHalfSize, y - yHalfSize, z - zHalfSize,
                          x + xHalfSize, y + yHalfSize, z + zHalfSize,
                          _color);
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
        return _other.__CollisionWithAABB(self).__Invert();
    }
    
    static __CollisionWithSphere = function(_other)
    {
        return _other.__CollisionWithAABB(self).__Invert();
    }
    
    static __CollisionWithRay = function(_other)
    {
        return _other.__CollisionWithAABB(self).__Invert();
    }
    
    static __CollisionWithAABB = function(_other)
    {
        var _aabb0_centre    = [x, y, z];
        var _aabb0_half_dims = [xHalfSize, yHalfSize, zHalfSize];
        
        with(_other)
        {
            var _aabb1_centre    = [x, y, z];
            var _aabb1_half_dims = [xHalfSize, yHalfSize, zHalfSize];
        }

        var _total_half_dims = BonkVecAdd(_aabb0_half_dims, _aabb1_half_dims);
        var _centre_distance = BonkVecSubtract( _aabb0_centre, _aabb1_centre);
        var _overlap = BonkVecSubtract(BonkVecAbs(_centre_distance ), _total_half_dims);

        if ((_overlap[0] >= 0) || (_overlap[1] >= 0) || (_overlap[2] >= 0))
        {
            return new BonkResult();
        }

        if ((_overlap[0] > _overlap[1]) && (_overlap[0] > _overlap[2]))
        {
            var _sign = sign(_centre_distance[0]);
            return new BonkResult(_sign, 0, 0, -_overlap[0]);
            
            //return [ _sign, 0, 0,
            //         _aabb0_centre[0] - _sign*_overlap[0], _aabb0_centre[1], _aabb0_centre[2],
            //         -_overlap[0] ];
        }
        else if ((_overlap[1] > _overlap[0]) && (_overlap[1] > _overlap[2]))
        {
            var _sign = sign(_centre_distance[1]);
            return new BonkResult(0, _sign, 0, -_overlap[1]);
            //return [ 0, _sign, 0,
            //         _aabb0_centre[0], _aabb0_centre[1] - _sign*_overlap[1], _aabb0_centre[2],
            //         -_overlap[1] ];
        }

        var _sign = sign(_centre_distance[2]);
        return new BonkResult(0, 0, _sign, -_overlap[2]);
        //return [ 0, 0, _sign,
        //         _aabb0_centre[0], _aabb0_centre[1], _aabb0_centre[2] - _sign*_overlap[2],
        //         -_overlap[2] ];
    }
    
    static __CollisionWithPlane = function(_plane)
    {
        var _centre    = [x, y, z];
        var _half_dims = [xNormal, yNormal, zNormal];
        
        with(_plane)
        {
            var _plane_point    = [x, y, z];
            var _plane_normal   = [xNormal, yNormal, zNormal];
            var _plane_distance = BonkVecDot(_plane_point, _plane_normal); //TODO - Optimise this!
        }

        var _sign_plane_normal = BonkVecSign(_plane_distance);
        
        var _edge_direction = [
            _half_dims[0]*_sign_plane_normal[0],
            _half_dims[1]*_sign_plane_normal[1],
            _half_dims[2]*_sign_plane_normal[2],
        ];
        
        var _corner_point = BonkVecSubtract(_centre, _edge_direction);

        var _distance = BonkVecDot(_plane_normal, _corner_point) - _plane_distance;
        if (_distance >= 0) return new BonkResult();

        return new BonkResult(_plane_normal[0], _plane_normal[1], _plane_normal[2]);
        
        //var _point = vec3_extend( _centre, _plane, -_distance );
        //return [ _plane[0], _plane[1], _plane[2],
        //         _point[0], _point[1], _point[2],
        //         -_distance ];
    }
    
    #endregion
}
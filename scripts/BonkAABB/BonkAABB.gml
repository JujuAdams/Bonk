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
        //TODO
        return new BonkResult();
    }
    
    #endregion
}
function BonkWall() constructor
{
    static __bonkType = __BONK_TYPE.PLANE;
    
    static toString = function()
    {
        return "wall";
    }
    
    
    
    #region Setters / Getters
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetNormal = function(_x = xNormal, _y = yNormal, _z = zNormal)
    {
        var _inverse_length = 1/sqrt(_x*_x + _y*_y + _z*_z);
        _x *= _inverse_length;
        _y *= _inverse_length;
        _z *= _inverse_length;
        
        xNormal = _x;
        yNormal = _y;
        zNormal = _z;
        
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
    
    static GetNormal = function()
    {
        return {
            x: xNormal,
            y: yNormal,
            z: zNormal,
        };
    }
    
    #endregion
    
    
    
    #region Variables
    
    x = 0;
    y = 0;
    z = 0;
    
    xNormal = 0;
    yNormal = 0;
    zNormal = 0;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_PLANE_DEFAULT_COLOR)
    {
        BonkDebugDrawPlane(x, y, z, xNormal, yNormal, zNormal, _color);
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
        return _other.__CollisionWithPlane(self).__Invert();
    }
    
    static __CollisionWithSphere = function(_other)
    {
        return _other.__CollisionWithPlane(self).__Invert();
    }
    
    static __CollisionWithRay = function(_other)
    {
        return _other.__CollisionWithPlane(self).__Invert();
    }
    
    static __CollisionWithAABB = function(_other)
    {
        return _other.__CollisionWithPlane(self).__Invert();
    }
    
    static __CollisionWithPlane = function(_other)
    {
        //If both plane share a point on the plane then they have to collide
        if ((x == _other.x) && (y == _other.y) && (z == _other.z))
        {
            return new BonkResult(true);
        }
        
        var _dot = dot_product_3d(xNormal, yNormal, zNormal, _other.xNormal, _other.yNormal, _other.zNormal);
        
        //If the planes aren't parallel then they must collide between the origin and infinity
        if (abs(_dot) != 1)
        {
            return new BonkResult(true);
        }
        
        //We know the planes are parallel
        //If the projection of a point on our plane with our normal is the same as the projection as a point on the other plane then the plane are coincident
        if (dot_product_3d(x, y, z, xNormal, yNormal, zNormal) == dot_product_3d(_other.x, _other.y, _other.z, xNormal, yNormal, zNormal))
        {
            return new BonkResult(true);
        }
        
        return new BonkResult(false);
    }
    
    static __CollisionWithTriangle = function(_other)
    {
        return new BonkResult(false);
    }
    
    static __CollisionWithCylinder = function(_other)
    {
        return new BonkResult(false);
    }
    
    #endregion
}
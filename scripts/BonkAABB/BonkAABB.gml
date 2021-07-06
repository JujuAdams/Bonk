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
    
    static __CollisionWithPoint = function(_point)
    {
        //TODO
        return new BonkResult();
    }
    
    static __CollisionWithSphere = function(_sphere)
    {
        //TODO
        return new BonkResult();
    }
    
    static __CollisionWithRay = function(_ray)
    {
        //TODO
        return new BonkResult();
    }
    
    static __CollisionWithAABB = function(_other)
    {
        //TODO
        return new BonkResult();
    }
    
    #endregion
}
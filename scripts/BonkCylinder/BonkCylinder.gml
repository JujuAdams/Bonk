function BonkCylinder() constructor
{
    static __bonkType = __BONK_TYPE.CYLINDER;
    
    static toString = function()
    {
        return "cylinder";
    }
    
    
    
    #region Setters / Getters
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetHeight = function(_height = 2*halfHeight)
    {
        halfHeight = 0.5*_height;
        
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
    
    static GetHeight = function()
    {
        return 2*halfHeight;
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
            z1: z - halfHeight,
            x2: x + radius,
            y2: y + radius,
            z2: z + halfHeight,
        };
    }
    
    #endregion
    
    
    
    #region Variables
    
    x = 0;
    y = 0;
    z = 0;
    
    halfHeight = 0;
    radius     = 0;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawCylinder(x, y, z, 2*halfHeight, radius, _color);
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
    }
    
    static __CollisionWithSphere = function(_other)
    {
    }
    
    static __CollisionWithRay = function(_other)
    {
    }
    
    static __CollisionWithAABB = function(_other)
    {
    }
    
    static __CollisionWithPlane = function(_other)
    {
    }
    
    static __CollisionWithCylinder = function(_other)
    {
    }
    
    #endregion
}
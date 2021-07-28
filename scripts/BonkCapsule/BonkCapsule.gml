function BonkCapsule() constructor
{
    static __bonkType = __BONK_TYPE.CAPSULE;
    
    static toString = function()
    {
        return "capsule";
    }
    
    
    
    #region Setters / Getters
    
    static SetA = function(_x = x1, _y = y1, _z = z1)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        return self;
    }
    
    static SetB = function(_x = x2, _y = y2, _z = z2)
    {
        x2 = _x;
        y2 = _y;
        z2 = _z;
        
        return self;
    }
    
    static SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        return self;
    }
    
    static GetA = function()
    {
        return {
            x: x1,
            y: y1,
            z: z1,
        };
    }
    
    static GetB = function()
    {
        return {
            x: x2,
            y: y2,
            z: z2,
        };
    }
    
    static GetRadius = function()
    {
        return radius;
    }
    
    static GetAABB = function()
    {
        return {
            x1: min(x1, x2) - radius,
            y1: min(y1, y2) - radius,
            z1: min(z1, z2) - radius,
            x2: max(x1, x2) + radius,
            y2: max(y1, y2) + radius,
            z2: max(z1, z2) + radius,
        };
    }
    
    #endregion
    
    
    
    #region Variables
    
    x1 = 0;
    y1 = 0;
    z1 = 0;
    
    x2 = 0;
    y2 = 0;
    z2 = 0;
    
    radius = 0;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawCapsule(x1, y1, z1, x2, y2, z2, radius, _color);
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
        return new BonkResult(false);
    }
    
    static __CollisionWithSphere = function(_other)
    {
        return new BonkResult(false);
    }
    
    static __CollisionWithRay = function(_other)
    {
        return new BonkResult(false);
    }
    
    static __CollisionWithAABB = function(_other)
    {
        return new BonkResult(false);
    }
    
    static __CollisionWithPlane = function(_other)
    {
        return new BonkResult(false);
    }
    
    static __CollisionWithTriangle = function(_other)
    {
        if (keyboard_check_pressed(ord("T")))
        {
            show_debug_message("!");
        }
        
        with(_other)
        {
            var _vertices = [[x1, y1, z1], [x2, y2, z2], [x3, y3, z3]];
            
            __CalculateNormal();
            var _normal = [normalX, normalY, normalZ];
    	    var _planeDistance = planeDistance;
        }
        
        var _ray0 = [x1, y1, z1];
        var _ray1 = [x2, y2, z2];
        
    	//Check if the ray is parallel to the plane, and early-out if so
    	var _dir = BonkVecSubtract(_ray1, _ray0);
    	var _n_dot_dir = BonkVecDot(_normal, _dir);
    	if (abs(_n_dot_dir) == 0) return new BonkResult(false);
        
    	//Find the point of collision with the triangle's plane
    	var _t = (_planeDistance - BonkVecDot(_normal, _ray0)) / _n_dot_dir;
        _t = clamp(_t, 0, 1);
        var _sphere_centre = BonkVecAdd(_ray0, BonkVecMultiply(_dir, _t));
        
    	for(var _i = 0; _i < 3; _i++)
    	{
            var _j = (_i+1) mod 3;
    	    var _vertex_i = _vertices[_i];
    	    var _vertex_j = _vertices[_j];
            
    	    var _t = BonkVecSubtract(_sphere_centre, _vertex_i);
    	    var _u = BonkVecSubtract(_vertex_j, _vertex_i);
    	    var _w = BonkVecCross(_t, _u);
            
    	    if (BonkVecDot(_w, _normal) <= 0)
    	    {
    	        var _dp = clamp(BonkVecDot(_u, _t) / BonkVecSqiareLength(_u), 0, 1);
    	        var _contactPoint = BonkVecAdd(_vertex_i, BonkVecMultiply(_u, _dp));
    	        break;
    	    }
    	}
        
    	if (_i >= 3)
    	{
    	    var _dp = BonkVecDot(_normal, _t);
    	    var _contactPoint = BonkVecSubtract(_sphere_centre, BonkVecMultiply(_normal, _dp));
    	}
        
    	var _pushoutNormal = BonkVecSubtract(_sphere_centre, _contactPoint);
    	var _pushoutDistance = BonkVecLength(_pushoutNormal);
    	if (_pushoutDistance >= radius) return new BonkResult(false);
        
        return new BonkResult(true);
    }
    
    static __CollisionWithCapsule = function(_other)
    {
        return new BonkResult(false);
    }
    
    #endregion
}
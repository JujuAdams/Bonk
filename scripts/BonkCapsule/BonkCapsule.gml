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
        var _p = BonkVecAdd(_ray0, BonkVecMultiply(_dir, _t));
        
    	//Check if P is inside the triangle
    	var _c = BonkVecCross(BonkVecSubtract(          _p, _vertices[0]),
    	                      BonkVecSubtract(_vertices[1], _vertices[0]));
    	if (BonkVecDot(_normal, _c) < -radius*radius) return new BonkResult(false);
        
    	var _c = BonkVecCross(BonkVecSubtract(          _p, _vertices[1]),
    	                      BonkVecSubtract(_vertices[2], _vertices[1]));
    	if (BonkVecDot(_normal, _c) < -radius*radius) return new BonkResult(false);
        
    	var _c = BonkVecCross(BonkVecSubtract(          _p, _vertices[2]),
    	                      BonkVecSubtract(_vertices[0], _vertices[2]));
    	if (BonkVecDot(_normal, _c) < -radius*radius) return new BonkResult(false);
        
        //FIXME - Return actual collision information
        return new BonkResult(true);
        
    	////Put the point of collision back into worldspace
    	//_p = vec3_add( _position, _p );
    	//return [ _plane[0], _plane[1], _plane[2],
    	//         _p[0], _p[1], _p[2] ];
    }
    
    static __CollisionWithCapsule = function(_other)
    {
        return new BonkResult(false);
    }
    
    #endregion
}
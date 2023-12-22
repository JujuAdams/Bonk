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
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawSphere(x, y, z, radius, _color);
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
            
            return new BonkResult(true, _directionX, _directionY, _directionZ, radius + _radius_other);
        }
        
        //Early out if the point is fully outside the sphere
        if (_length >= radius + _radius_other) return new BonkResult(false);
        
        var _inverseLength = 1/_length;
        _directionX *= _inverseLength;
        _directionY *= _inverseLength;
        _directionZ *= _inverseLength;
        
        return new BonkResult(true, _directionX, _directionY, _directionZ, radius + _radius_other - _length);
    }
    
    static __CollisionWithRay = function(_other)
    {
        return _other.__CollisionWithRay(self).__Invert();
    }
    
    static __CollisionWithAABB = function(_aabb)
    {
        var _sphere_centre  = [x, y, z];
        var _sphere_radius  = radius;
        
        with(_aabb)
        {
            var _aabb_centre    = [x, y, z];
            var _aabb_half_size = [xHalfSize, yHalfSize, zHalfSize];
        }
        
        var _local_sphere_pos = BonkVecSubtract(_sphere_centre, _aabb_centre);
        var _edge_point = [ clamp(_local_sphere_pos[0], -_aabb_half_size[0], _aabb_half_size[0]),
                            clamp(_local_sphere_pos[1], -_aabb_half_size[1], _aabb_half_size[1]),
                            clamp(_local_sphere_pos[2], -_aabb_half_size[2], _aabb_half_size[2]) ];
        
        var _overlap = BonkVecSubtract(_aabb_half_size, BonkVecAbs(_local_sphere_pos));
        
        if ((_overlap[0] < 0) || (_overlap[1] < 0) || (_overlap[2] < 0))
        {
            var _edge_to_local = BonkVecSubtract(_local_sphere_pos, _edge_point);
            var _distance = BonkVecLength(_edge_to_local);
            if ( _distance >= _sphere_radius ) return new BonkResult(false);
            
            var _normal = BonkVecNormalize(_edge_to_local);
            //var _pushout_point = BonkVecAdd(_aabb_centre, BonkVecAdd(_edge_point, BonkVecMultiply(_normal, _sphere_radius)));
            return new BonkResult(true, _normal[0], _normal[1], _normal[2], _distance);
            //return [ _normal[0], _normal[1], _normal[2],
            //         _pushout_point[0], _pushout_point[1], _pushout_point[2],
            //         _distance ];
        }
        
        if ((_overlap[0] <= _overlap[1]) && (_overlap[0] <= _overlap[2]))
        {
            var _sign = (_local_sphere_pos[0] >= 0)? 1 : -1;
            return new BonkResult(true, _sign, 0, 0, -_overlap[0]);
            //return [ _sign, 0, 0,
            //         _sphere_centre[0] + _sign*(_sphere_radius + _overlap[0]), _sphere_centre[1], _sphere_centre[2],
            //         -_overlap[0] ];
        }
        else if ((_overlap[1] <= _overlap[2]))
        {
            var _sign = (_local_sphere_pos[1] >= 0)? 1 : -1;
            return new BonkResult(0, _sign, 0, -_overlap[1]);
            //return [ 0, _sign, 0,
            //         _sphere_centre[0], _sphere_centre[1] + _sign*(_sphere_radius + _overlap[1]), _sphere_centre[2],
            //         -_overlap[1] ];
        }
        
        var _sign = (_local_sphere_pos[2] >= 0)? 1 : -1;
        return new BonkResult(0, 0, _sign, -_overlap[2]);
        //return [ 0, 0, _sign,
        //         _sphere_centre[0], _sphere_centre[1], _sphere_centre[2] + _sign*(_sphere_radius + _overlap[2]),
        //         -_overlap[2] ];
    }
    
    static __CollisionWithPlane = function(_plane)
    {
        with(_plane)
        {
            var _plane_point    = [x, y, z];
            var _plane_normal   = [xNormal, yNormal, zNormal];
            var _plane_distance = BonkVecDot(_plane_point, _plane_normal); //TODO - Optimise this!
        }
        
        var _sphere_min = BonkVecDot([x, y, z], _plane_normal) - radius;
        if (_plane_distance <= _sphere_min) return new BonkResult(false);
        
        return new BonkResult(true, _plane_normal[0], _plane_normal[1], _plane_normal[2], _plane_distance - _sphere_min);
        
        //var _pushout_point = vec3_extend( _sphere_centre, _plane, _distance - _sphere_min );
        //return [ _plane[0], _plane[1], _plane[2],
        //         _pushout_point[0], _pushout_point[1], _pushout_point[2],
        //         _distance - _sphere_min ];
    }
    
    static __CollisionWithTriangle = function(_other)
    {
    	var _sphere_centre = [x, y, z];
        
        with(_other)
        {
            var _vertices = [[x1, y1, z1], [x2, y2, z2], [x3, y3, z3]];
            
            __CalculateNormal();
            var _normal = [normalX, normalY, normalZ];
        }
        
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
    	        var _dp = clamp(BonkVecDot(_u, _t) / BonkVecSquareLength(_u), 0, 1);
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
    
    static __CollisionWithCylinder = function(_other)
    {
        return new BonkResult(false);
    }
    
    #endregion
}
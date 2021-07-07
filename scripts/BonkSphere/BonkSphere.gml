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
            
            return new BonkResult(_directionX, _directionY, _directionZ, radius + _radius_other);
        }
        
        //Early out if the point is fully outside the sphere
        if (_length >= radius + _radius_other) return new BonkResult();
        
        var _inverseLength = 1/_length;
        _directionX *= _inverseLength;
        _directionY *= _inverseLength;
        _directionZ *= _inverseLength;
        
        return new BonkResult(_directionX, _directionY, _directionZ, radius + _radius_other - _length);
    }
    
    static __CollisionWithRay = function(_other)
    {
        return _other.__CollisionWithRay(self).__Invert();
    }
    
    static __CollisionWithAABB = function(_aabb)
    {
        //TODO
        return new BonkResult();
        
        //var _sphere_centre  = argument0;
        //var _sphere_radius  = argument1;
        //var _aabb_centre    = argument2;
        //var _aabb_half_size = argument3;
        //
        //var _local_sphere_pos = vec3_subtract( _sphere_centre, _aabb_centre );
        //var _edge_point = [ clamp( _local_sphere_pos[0], -_aabb_half_size[0], _aabb_half_size[0] ),
        //                    clamp( _local_sphere_pos[1], -_aabb_half_size[1], _aabb_half_size[1] ),
        //                    clamp( _local_sphere_pos[2], -_aabb_half_size[2], _aabb_half_size[2] ) ];
        //
        //var _overlap = vec3_subtract( _aabb_half_size, vec3_abs( _local_sphere_pos ) );
        //
        //if ( _overlap[0] < 0 ) || ( _overlap[1] < 0 ) || ( _overlap[2] < 0 )
        //{
        //    var _edge_to_local = vec3_subtract( _local_sphere_pos, _edge_point );
        //    var _distance = vec3_length( _edge_to_local );
        //    if ( _distance >= _sphere_radius ) return undefined;
        //    var _normal = vec3_normalise( _edge_to_local );
        //
        //    var _pushout_point = vec3_add( _aabb_centre, vec3_add( _edge_point, vec3_scale( _normal, _sphere_radius ) ) );
        //
        //    return [ _normal[0], _normal[1], _normal[2],
        //             _pushout_point[0], _pushout_point[1], _pushout_point[2],
        //             _distance ];
        //}
        //
        //if ( _overlap[0] <= _overlap[1] ) && ( _overlap[0] <= _overlap[2] )
        //{
        //    var _sign = (_local_sphere_pos[0] >= 0)? 1 : -1;
        //    return [ _sign, 0, 0,
        //             _sphere_centre[0] + _sign*(_sphere_radius + _overlap[0]), _sphere_centre[1], _sphere_centre[2],
        //             -_overlap[0] ];
        //}
        //else if ( _overlap[1] <= _overlap[2] )
        //{
        //    var _sign = (_local_sphere_pos[1] >= 0)? 1 : -1;
        //    return [ 0, _sign, 0,
        //             _sphere_centre[0], _sphere_centre[1] + _sign*(_sphere_radius + _overlap[1]), _sphere_centre[2],
        //             -_overlap[1] ];
        //}
        //
        //var _sign = (_local_sphere_pos[2] >= 0)? 1 : -1;
        //return [ 0, 0, _sign,
        //         _sphere_centre[0], _sphere_centre[1], _sphere_centre[2] + _sign*(_sphere_radius + _overlap[2]),
        //         -_overlap[2] ];
    }
    
    #endregion
}
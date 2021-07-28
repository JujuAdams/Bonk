function BonkRay() constructor
{
    static __bonkType = __BONK_TYPE.POINT;
    
    static toString = function()
    {
        return "point";
    }
    
    
    
    #region Setters / Getters
    
    static SetA = function(_x = x1, _y = y1, _z = z1)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        if (isRay)
        {
            x2 = x1 + __BONK_VERY_LARGE*(x2 - x1);
            y2 = y1 + __BONK_VERY_LARGE*(y2 - y1);
            z2 = z1 + __BONK_VERY_LARGE*(z2 - z1);
        }
        
        return self;
    }
    
    static SetB = function(_x = x2, _y = y2, _z = z2)
    {
        x2 = _x;
        y2 = _y;
        z2 = _z;
        
        isRay = false;
        
        return self;
    }
    
    static SetRay = function(_x, _y, _z, _dx, _dy, _dz)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        var _d = __BONK_VERY_LARGE / sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
        x2 = x1 + _d*_dx;
        y2 = y1 + _d*_dy;
        z2 = z1 + _d*_dz;
        
        isRay = true;
        
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
    
    static GetRay = function()
    {
        return isRay;
    }
    
    #endregion
    
    
    
    #region Variables
    
    x1 = 0;
    y1 = 0;
    z1 = 0;
    
    x2 = 0;
    y2 = 0;
    z2 = 0;
    
    isRay = false;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawRay(x1, y1, z1, x2, y2, z2, _color);
    }
    
    #endregion
    
    
    
    #region General Collision Handler
    
    static Collision = function(_other)
    {
        return __BonkSharedCollisionHandler(_other);
    }
    
    #endregion
    
    
    
    #region Specific Collisions
    
    static __CollisionWithPoint = function(_point_struct)
    {
        var _point = [_point_struct.x, _point_struct.y, _point_struct.z];
        var _a     = [x1, y1, z1];
        var _b     = [x2, y2, z2];
        
        var _point_local = BonkVecSubtract(_point, _a);
        var _diff        = BonkVecSubtract(_b, _a);
        
        var _dot = BonkVecDot(_point_local, _diff);
        if (_dot < 0) return new BonkResult(false);
        
        var _square_length = BonkVecSqiareLength(_diff);
        var _t = _dot / _square_length;
        if (_t > 1) return new BonkResult(false);
        
        var _new_point = BonkVecMultiply(_diff, _t);
        if (!BonkVecEqual(_new_point, _point_local)) return new BonkResult(false);
        
        var _length = sqrt(_square_length);
        var _normal = BonkVecMultiply( _diff, -1/_length); //Bounce the ray directly off the point
        
        return (new BonkResult(true, _normal[0], _normal[1], _normal[2], math_get_epsilon())).__SetPoint(_point[0], _point[1], _point[2]);
    }
    
    static __CollisionWithSphere = function(_sphere)
    {
        var _centre = [_sphere.x, _sphere.y, _sphere.z];
        var _radius = _sphere.radius;
        var _ray_a  = [x1, y1, z1];
        var _ray_b  = [x2, y2, z2];
        
        var _dir = BonkVecSubtract( _ray_b, _ray_a);
        var _length = BonkVecLength(_dir);
        
        if (_length <= 0) return new BonkResult(false);
        
        _dir = BonkVecMultiply(_dir, 1/_length);
        var _local = BonkVecSubtract(_ray_a, _centre);
        var _b = BonkVecDot(_local, _dir);
        var _c = BonkVecSqiareLength(_local) - _radius*_radius;
        
        var _discriminant = _b*_b - _c;
        if (_discriminant < 0) return new BonkResult(false);
        
        var _t_min = -_b - sqrt(_discriminant);
        var _t_max = -_b + sqrt(_discriminant);
        
        if (_length < _t_min) return new BonkResult(false);
        
        if (_t_min < 0)
        {
            if (_t_max < 0) return new BonkResult(false);
            var _point = BonkVecAdd(_ray_a, BonkVecMultiply(_dir, _t_max));
        }
        else
        {
            var _point = BonkVecAdd(_ray_a, BonkVecMultiply(_dir, _t_min));
        }
        
        var _normal = BonkVecMultiply(BonkVecSubtract(_point, _centre), 1/_radius);
        
        return (new BonkResult(true, _normal[0], _normal[1], _normal[2])).__SetPoint(_point[0], _point[1], _point[2]);
    }
    
    static __CollisionWithRay = function(_other)
    {
        var _self_a  = [x1, y1, z1];
        var _self_b  = [x2, y2, z2];
        
        with(_other)
        {
            var _other_a  = [x1, y1, z1];
            var _other_b  = [x2, y2, z2];
        }
        
        var _self_direction  = BonkVecSubtract( _self_b,  _self_a );
        var _other_direction = BonkVecSubtract( _other_b, _other_a);
        var _other_local     = BonkVecSubtract( _other_a, _self_a );
        
        var _cross = BonkVecCross(_self_direction, _other_direction);
        
        if (abs(BonkVecDot(_other_local, _cross)) > 0)
        {
            //Not coplanar
            return new BonkResult(false);
        }
        
        var _t = BonkVecDot(BonkVecCross(_other_local, _other_direction), _cross) / BonkVecSqiareLength(_cross);
        if ((_t < 0) || (_t > 1)) return new BonkResult(false);
        
        var _point = BonkVecAdd(_self_a, BonkVecMultiply(_self_direction, _t));
        
        //See if this lies on the segment
        if (BonkVecSqiareLength(BonkVecSubtract(_point, _self_a)) + BonkVecSqiareLength(BonkVecSubtract(_point, _self_b)) > BonkVecSqiareLength(_other_direction))
        {
            return new BonkResult(false);
        }
        
        return new BonkResult(undefined, undefined, undefined, undefined, _point[0], _point[1], _point[2]);
    }
    
    static __CollisionWithAABB = function(_aabb)
    {
        var _ray0 = [x1, y1, z1];
        var _ray1 = [x2, y2, z2];
        
        with(_aabb)
        {
            var _aabb_centre    = [x, y, z];
            var _aabb_half_dims = [xHalfSize, yHalfSize, zHalfSize];
        }
        
        var _dir = BonkVecSubtract( _ray1, _ray0 );
        if ((_dir[0] == 0) && (_dir[1] == 0) && (_dir[2] == 0)) return new BonkResult(false);
        
        var _aabb_min = BonkVecSubtract(_aabb_centre, _aabb_half_dims);
        var _aabb_max = BonkVecAdd(_aabb_centre, _aabb_half_dims);
        
        var _t_min = undefined;
        var _t_max = undefined;
        
        if (_dir[0] != 0)
        {
            var _t_min = (_aabb_min[0] - _ray0[0]) / _dir[0];
            var _t_max = (_aabb_max[0] - _ray0[0]) / _dir[0];
            if (_t_min > _t_max) { var _temp = _t_max; _t_max = _t_min; _t_min = _temp; }
        }
        
        if (_dir[1] != 0)
        {
            var _t_y_min = (_aabb_min[1] - _ray0[1]) / _dir[1];
            var _t_y_max = (_aabb_max[1] - _ray0[1]) / _dir[1];
            if (_t_y_min > _t_y_max) { var _temp = _t_y_max; _t_y_max = _t_y_min; _t_y_min = _temp; }
        
            if (_t_min == undefined)
            {
                _t_min = _t_y_min;
                _t_max = _t_y_max;
            }
            else
            {
                if ((_t_min > _t_y_max) || ( _t_y_min > _t_max)) return new BonkResult(false);
                if (_t_y_min > _t_min) _t_min = _t_y_min;
                if (_t_y_max < _t_max) _t_max = _t_y_max;
            }
        }
        
        if (_dir[2] != 0)
        {
            var _t_z_min = (_aabb_min[2] - _ray0[2]) / _dir[2];
            var _t_z_max = (_aabb_max[2] - _ray0[2]) / _dir[2];
            if (_t_z_min > _t_z_max) { var _temp = _t_z_max; _t_z_max = _t_z_min; _t_z_min = _temp; }
        
            if (_t_min == undefined)
            {
                _t_min = _t_z_min;
                _t_max = _t_z_max;
            }
            else
            {
                if ((_t_min > _t_z_max) || (_t_z_min > _t_max)) return new BonkResult(false);
                if (_t_z_min > _t_min) _t_min = _t_z_min;
                if (_t_z_max < _t_max) _t_max = _t_z_max;
            }
        }
        
        if (_t_min == undefined) return new BonkResult(false);
        
        var _t = _t_min;
        if ((_t_min <= 0) || (_t_min >= 1))
        {
            if ((_t_max <= 0) || (_t_max >= 1)) return new BonkResult(false);
            var _t = _t_max;
        }
        
        var _point = BonkVecAdd(_ray0, BonkVecMultiply(BonkVecSubtract(_ray1, _ray0), _t));
        if (!__BonkAABBPointInsideMinMax(_point, _aabb_min, _aabb_max)) return new BonkResult(false);
        
        var _normal = BonkVecSubtract(_point, _aabb_centre);
        _normal[0] /= _aabb_half_dims[0];
        _normal[1] /= _aabb_half_dims[1];
        _normal[2] /= _aabb_half_dims[2];
        
        _normal[0] = (_normal[0] <= -1)? -1 : ((_normal[0] >= 1)? 1 : 0);
        _normal[1] = (_normal[1] <= -1)? -1 : ((_normal[1] >= 1)? 1 : 0);
        _normal[2] = (_normal[2] <= -1)? -1 : ((_normal[2] >= 1)? 1 : 0);
        
        return (new BonkResult(true, _normal[0], _normal[1], _normal[2])).__SetPoint(_point[0], _point[1], _point[2]);
    }
    
    static __CollisionWithPlane = function(_plane)
    {
        var _ray0  = [x1, y1, z1];
        var _ray1  = [x2, y2, z2];
        
        with(_plane)
        {
            var _plane_point    = [x, y, z];
            var _plane_normal   = [xNormal, yNormal, zNormal];
            var _plane_distance = BonkVecDot(_plane_point, _plane_normal); //TODO - Optimise this!
        }

        var _dir = BonkVecSubtract(_ray1, _ray0); //TODO - Optimise this!

        var _v_dot_n = BonkVecDot(_dir, _plane_normal);
        if (_v_dot_n == 0) return new BonkResult(false); //Parallel to the plane

        var _r0_dot_n = BonkVecDot(_ray0, _plane);
        var _t = (_plane_distance - _r0_dot_n) / _v_dot_n;

        if ((_t < 0) || (_t > 1)) return new BonkResult(false);
        
        var _pos = BonkVecAdd(_ray0, BonkVecMultiply(BonkVecSubtract(_ray1, _ray0), _t));
        return (new BonkResult(true, _plane_normal[0], _plane_normal[1], _plane_normal[2])).__SetPoint(_pos[0], _pos[1], _pos[2]);
    }
    
    static __CollisionWithCylinder = function(_other)
    {
    }
    
    #endregion
}
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
        
        return self;
    }
    
    static SetB = function(_x = x2, _y = y2, _z = z2)
    {
        x2 = _x;
        y2 = _y;
        z2 = _z;
        
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
    
    #endregion
    
    
    
    #region Variables
    
    x1 = 0;
    y1 = 0;
    z1 = 0;
    
    x2 = 0;
    y2 = 0;
    z2 = 0;
    
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
        if (_dot < 0) return new BonkResult();
        
        var _square_length = BonkVecSqiareLength(_diff);
        var _t = _dot / _square_length;
        if (_t > 1) return new BonkResult();
        
        var _new_point = BonkVecMultiply(_diff, _t);
        if (!BonkVecEqual(_new_point, _point_local)) return new BonkResult();
        
        var _length = sqrt(_square_length);
        var _normal = BonkVecMultiply( _diff, -1/_length); //Bounce the ray directly off the point
        
        return new BonkResult(_normal[0], _normal[1], _normal[2], undefined);
    }
    
    static __CollisionWithSphere = function(_sphere)
    {
        var _centre = [_sphere.x, _sphere.y, _sphere.z];
        var _radius = _sphere.radius;
        var _ray_a  = [x1, y1, z1];
        var _ray_b  = [x2, y2, z2];
        
        var _dir = BonkVecSubtract( _ray_b, _ray_a);
        var _length = BonkVecLength(_dir);
        
        if (_length <= 0) return new BonkResult();
        
        _dir = BonkVecMultiply(_dir, 1/_length);
        var _local = BonkVecSubtract(_ray_a, _centre);
        var _b = BonkVecDot(_local, _dir);
        var _c = BonkVecSqiareLength(_local) - _radius*_radius;
        
        var _discriminant = _b*_b - _c;
        if (_discriminant < 0) return new BonkResult();
        
        var _t_min = -_b - sqrt(_discriminant);
        var _t_max = -_b + sqrt(_discriminant);
        
        if (_length < _t_min) return new BonkResult();
        
        if (_t_min < 0)
        {
            if (_t_max < 0) return new BonkResult();
            var _point = BonkVecAdd(_ray_a, BonkVecMultiply(_dir, _t_max));
        }
        else
        {
            var _point = BonkVecAdd(_ray_a, BonkVecMultiply(_dir, _t_min));
        }
        
        var _normal = BonkVecMultiply(BonkVecSubtract(_point, _centre), 1/_radius);
        
        return new BonkResult(_normal[0], _normal[1], _normal[2], undefined, _point[0], _point[1], _point[2]);
    }
    
    static __CollisionWithRay = function(_other)
    {
        //TODO
        return new BonkResult();
    }
    
    #endregion
}
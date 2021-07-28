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
        
        var _ray1 = [x1, y1, z1];
        var _ray2 = [x2, y2, z2];
        
        var _distance1 = (BonkVecDot(_normal, _ray1) - _planeDistance) - radius;
        var _distance2 = (BonkVecDot(_normal, _ray2) - _planeDistance) - radius;
        
        if (((_distance1 > 0) && (_distance2 > 0)) || ((_distance1 < -radius) && (_distance2 < -radius)))
        {
            return new BonkResult(false);
        }
        
        var _delta = abs(_distance1 / (abs(_distance1) + abs(_distance2)));
        var _intersectionPoint = BonkVecAdd(_ray1, BonkVecMultiply(_ray2, _delta));
        
        if (_other.ContainsPoint(_intersectionPoint))
        {
            return new BonkResult(true);
        }
        
        var _capsuleAxis = [_ray1, _ray2];
        var _edges = [[_vertices[0], _vertices[1]], [_vertices[1], _vertices[2]], [_vertices[2], _vertices[0]]];
        
        var _i = 0;
        repeat(3)
        {
            var _edge = _edges[_i];
            
            var _minimumPoints = LineLineMinimumPoints(_capsuleAxis, _edge);
            
            if (BonkVecSqiareLength(BonkVecSubtract(_minimumPoints[1], _minimumPoints[0])) < radius*radius)
            {
                return new BonkResult(true);
            }
            
            ++_i;
        }
        
        return new BonkResult(false);
    }
    
    static __CollisionWithCapsule = function(_other)
    {
        return new BonkResult(false);
    }
    
    #endregion
    
    
    
    #region Helpers
    
    static LineLineMinimumPoints = function(_lineA, _lineB)
    {
        var _r = BonkVecSubtract(_lineA[1], _lineA[0]);
        var _s = BonkVecSubtract(_lineB[1], _lineB[0]);
        var _w = BonkVecSubtract(_lineB[0], _lineA[0]);
        
        var _a = BonkVecDot(_r, _s);
        var _b = BonkVecDot(_r, _r);
        var _c = BonkVecDot(_s, _s);
        var _d = BonkVecDot(_s, _w);
        var _e = BonkVecDot(_r, _w);
        
        var _t1 = undefined;
        var _t2 = undefined;
        var _divisor = _b*_c - _a*_a;
        
        if (abs(_divisor) <= 0)
        {
            var _d1 = -_d / _c;
            var _d2 = (_a - _d) / _c;
            
            if (abs(_d1 - 0.5) < abs(_d2 - 0.5))
            {
                _t1 = 0;
                _t2 = _d1;
            }
            else
            {
                _t1 = 1;
                _t2 = _d2;
            }
        }
        else
        {
            _t1 = (_d*_a + _e*_c) / _divisor;
            _t2 = (_t1*_a - _d) / _c;
        }
        
        _t1 = clamp(_t1, 0, 1);
        _t2 = clamp(_t2, 0, 1);
        
        return [ BonkVecAdd(_lineA[0], BonkVecMultiply(_r, _t1)),
                 BonkVecAdd(_lineB[0], BonkVecMultiply(_s, _t2)) ];
    }
    
    #endregion
}
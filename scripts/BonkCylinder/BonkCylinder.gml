function BonkCylinder() constructor
{
    static __bonkType = __BONK_TYPE.CYLINDER;
    
    static toString = function()
    {
        return "cylinder";
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
    
    height = 0;
    radius = 0;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawCylinder(x1, y1, z1, height, radius, _color);
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
        //Similar to the solution three.js uses
        
        with(_other)
        {
            __CalculateNormal();
            var _normal = [normalX, normalY, normalZ];
    	    var _planeDistance = planeDistance;
        }
        
        var _ray1 = [x1, y1, z1];
        var _ray2 = [x2, y2, z2];
        
        var _distance1 = (BonkVecDot(_normal, _ray1) - _planeDistance) - radius;
        var _distance2 = (BonkVecDot(_normal, _ray2) - _planeDistance) - radius;
        
        if (((_distance1 > 0) && (_distance2 > 0)) || ((_distance1 < -2*radius) && (_distance2 < -2*radius)))
        {
            return new BonkResult(false);
        }
        
        var _delta = abs(_distance1 / (abs(_distance1) + abs(_distance2)));
        var _intersectionPoint = BonkVecAdd(_ray1, BonkVecMultiply(BonkVecSubtract(_ray2, _ray1), _delta));
        
        if (_other.ContainsPoint(_intersectionPoint))
        {
            return new BonkResult(true, _normal[0], _normal[1], _normal[2], abs(min(_distance1, _distance2)));
        }
        
        var _minimumPoints = LineLineMinimumPoints(_ray1, _ray2,
                                                   [_other.x1, _other.y1, _other.z1],
                                                   [_other.x2, _other.y2, _other.z2]);
        var _distance = point_distance_3d(_minimumPoints[0][0], _minimumPoints[0][1], _minimumPoints[0][2],
                                          _minimumPoints[1][0], _minimumPoints[1][1], _minimumPoints[1][2]);
        if (_distance < radius)
        {
            _distance = max(math_get_epsilon(), _distance);
            var _rx = (_minimumPoints[1][0] - _minimumPoints[0][0]) / _distance;
            var _ry = (_minimumPoints[1][1] - _minimumPoints[0][1]) / _distance;
            var _rz = (_minimumPoints[1][2] - _minimumPoints[0][2]) / _distance;
            __BonkTrace("A: ", _rx, ",", _ry, ",", _rz);
            return new BonkResult(true, _rx, _ry, _rz, radius - _distance);
        }
        
        var _minimumPoints = LineLineMinimumPoints(_ray1, _ray2,
                                                   [_other.x2, _other.y2, _other.z2],
                                                   [_other.x3, _other.y3, _other.z3]);
        var _distance = point_distance_3d(_minimumPoints[0][0], _minimumPoints[0][1], _minimumPoints[0][2],
                                          _minimumPoints[1][0], _minimumPoints[1][1], _minimumPoints[1][2]);
        if (_distance < radius)
        {
            _distance = max(math_get_epsilon(), _distance);
            var _rx = (_minimumPoints[1][0] - _minimumPoints[0][0]) / _distance;
            var _ry = (_minimumPoints[1][1] - _minimumPoints[0][1]) / _distance;
            var _rz = (_minimumPoints[1][2] - _minimumPoints[0][2]) / _distance;
            return new BonkResult(true, _rx, _ry, _rz, radius - _distance);
        }
        
        var _minimumPoints = LineLineMinimumPoints(_ray1, _ray2,
                                                   [_other.x3, _other.y3, _other.z3],
                                                   [_other.x1, _other.y1, _other.z1]);
        var _distance = point_distance_3d(_minimumPoints[0][0], _minimumPoints[0][1], _minimumPoints[0][2],
                                          _minimumPoints[1][0], _minimumPoints[1][1], _minimumPoints[1][2]);
        if (_distance < radius)
        {
            _distance = max(math_get_epsilon(), _distance);
            var _rx = (_minimumPoints[1][0] - _minimumPoints[0][0]) / _distance;
            var _ry = (_minimumPoints[1][1] - _minimumPoints[0][1]) / _distance;
            var _rz = (_minimumPoints[1][2] - _minimumPoints[0][2]) / _distance;
            return new BonkResult(true, _rx, _ry, _rz, radius - _distance);
        }
        
        return new BonkResult(false);
    }
    
    static __CollisionWithCylinder = function(_other)
    {
        return new BonkResult(false);
    }
    
    #endregion
    
    
    
    #region Helpers
    
    static LineLineMinimumPoints = function(_p1, _p2, _q1, _q2)
    {
        //https://zalo.github.io/blog/closest-point-between-segments/
        
        var _pDir = BonkVecSubtract(_p2, _p1);
        var _qDir = BonkVecSubtract(_q2, _q1);
        var _pSquareLength = BonkVecSquareLength(_pDir);
        var _qSquareLength = BonkVecSquareLength(_qDir);
        
        var _inPlaneA = BonkVecSubtract(_p1, BonkVecMultiply(_qDir, BonkVecDot(BonkVecSubtract(_p1, _q1), _qDir) / _qSquareLength));
        var _inPlaneB = BonkVecSubtract(_p2, BonkVecMultiply(_qDir, BonkVecDot(BonkVecSubtract(_p2, _q1), _qDir) / _qSquareLength));
        var _inPlaneBA = BonkVecSubtract(_inPlaneB, _inPlaneA);
        
        var _squareLength = BonkVecSquareLength(_inPlaneBA);
        if (_squareLength == 0)
        {
            var _t = 0;
        }
        else
        {
            var _t = BonkVecDot(BonkVecSubtract(_q1, _inPlaneA), _inPlaneBA) / _squareLength;
                _t = clamp(_t, 0, 1);
        }
        
        var _segABtoLineCD = BonkVecAdd(_p1, BonkVecMultiply(_pDir, _t));
        
        var _t = BonkVecDot(BonkVecSubtract(_segABtoLineCD, _q1), _qDir) / _qSquareLength;
            _t = clamp(_t, 0, 1);
        var _segCDtoSegAB = BonkVecAdd(_q1, BonkVecMultiply(_qDir, _t));
        
        var _t = BonkVecDot(BonkVecSubtract(_segCDtoSegAB, _p1), _pDir) / _pSquareLength;
            _t = clamp(_t, 0, 1);
        var _segABtoSegCD = BonkVecAdd(_p1, BonkVecMultiply(_pDir, _t));
        
        return [ _segCDtoSegAB, _segABtoSegCD ];
        
        // three.js
        // This seems to be very buggy and I'm sure not why
        
        //var _r = BonkVecSubtract(_p2, _p1);
        //var _s = BonkVecSubtract(_q2, _q1);
        //var _w = BonkVecSubtract(_q1, _p1);
        //
        //var _a = BonkVecDot(_r, _s);
        //var _b = BonkVecDot(_r, _r);
        //var _c = BonkVecDot(_s, _s);
        //var _d = BonkVecDot(_s, _w);
        //var _e = BonkVecDot(_r, _w);
        //
        //var _t1 = undefined;
        //var _t2 = undefined;
        //var _divisor = _b*_c - _a*_a;
        //
        //if (_divisor == 0)
        //{
        //    //Lines are coplanar and parallel
        //    var _d1 = -_d / _c;
        //    var _d2 = (_a - _d) / _c;
        //    
        //    if (abs(_d1 - 0.5) < abs(_d2 - 0.5))
        //    {
        //        _t1 = 0;
        //        _t2 = _d1;
        //    }
        //    else
        //    {
        //        _t1 = 1;
        //        _t2 = _d2;
        //    }
        //}
        //else
        //{
        //    _t1 = (_d*_a + _e*_c) / _divisor;
        //    _t2 = (_t1*_a - _d) / _c;
        //}
        //
        //_t1 = clamp(_t1, 0, 1);
        //_t2 = clamp(_t2, 0, 1);
        //
        //return [ BonkVecAdd(_p1, BonkVecMultiply(_r, _t1)),
        //         BonkVecAdd(_q2, BonkVecMultiply(_s, -_t2)) ];
    }
    
    #endregion
}
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
    
    static __CollisionWithCylinder = function(_other)
    {
        return new BonkResult(false);
    }
    
    static __CollisionWithTriangle = function(_other)
    {
        if (keyboard_check_pressed(ord("T")))
        {
            show_debug_message("!");
        }
        
        var _cylinder_origin = [x, y, z];
        
        var _triangle = [ [_other.x1, _other.y1, _other.z1],
                          [_other.x2, _other.y2, _other.z2],
                          [_other.x3, _other.y3, _other.z3] ];
        
        //Move the triangle into the 
        _triangle[@ 0] = BonkVecSubtract(_triangle[0], _cylinder_origin);
        _triangle[@ 1] = BonkVecSubtract(_triangle[1], _cylinder_origin);
        _triangle[@ 2] = BonkVecSubtract(_triangle[2], _cylinder_origin);
        
        #region Sort the triangle vertices so that z0 <= z1 <= z2
        
        var _tri_z0 = _triangle[0][2];
        var _tri_z1 = _triangle[1][2];
        var _tri_z2 = _triangle[2][2];
        
        if (_tri_z0 < _tri_z1)
        {
            if (_tri_z2 < _tri_z0)
            {
                var _t0 = 2;
                var _t1 = 0;
                var _t2 = 1;
            }
            else if (_tri_z2 < _tri_z1)
            {
                var _t0 = 0;
                var _t1 = 2;
                var _t2 = 1;
            }
            else
            {
                var _t0 = 0;
                var _t1 = 1;
                var _t2 = 2;
            }
        }
        else
        {
            if (_tri_z2 < _tri_z1)
            {
                var _t0 = 2;
                var _t1 = 1;
                var _t2 = 0;
            }
            else if (_tri_z2 < _tri_z0)
            {
                var _t0 = 1;
                var _t1 = 2;
                var _t2 = 0;
            }
            else
            {
                var _t0 = 1;
                var _t1 = 0;
                var _t2 = 2;
            }
        }
        
        #endregion
        
        //Maintain the xy-components and z-components separately. The z-components are used for clipping against bottom and top
        //planes of the cylinder. The xy-components are used for disk-containment tests x*x + y*y <= r*r
        var _z_array = [_triangle[_t0][2], _triangle[_t1][2], _triangle[_t2][2]];
        
        //Attempt an early exit by testing whether the triangle is strictly outside the cylinder slab -h/2 < z < h/2
        if ((_z_array[0] > halfHeight) || (_z_array[2] < -halfHeight))
        {
            return new BonkResult(false);
        }
        
        //Project the triangle vertices onto the xy-plane
        var _xy_array = [ [_triangle[_t0][0], _triangle[_t0][1]],
                          [_triangle[_t1][0], _triangle[_t1][1]],
                          [_triangle[_t2][0], _triangle[_t2][1]] ];
        
        //Attempt an early exit when the triangle does not have to be clipped
        if ((-halfHeight <= _z_array[0]) && (_z_array[2] <= halfHeight))
        {
            //The triangle is between the planes of the top-disk and the bottom disk of the cylinder. Determine whether the
            //projection of the triangle onto a plane perpendicular to the cylinder axis overlaps the disk of projection
            //of the cylinder onto the same plane
            var _intersects = __BonkDiskOverlapsPolygon(_xy_array, radius);
            return new BonkResult(_intersects);
        }
        
        //Clip against |z| <= h/2. At this point we know that z2 >= -h/2 and z0 <= h/2 with either z0 < -h/2 or z2 > h/2 or both. The
        //test-intersection query involves testing for overlap between the xy-projection of the clipped triangle and the xy-projection
        //of the cylinder (a disk in the projection plane). The code below computes the vertices of the projection of the clipped
        //triangle. The t-values of the triangle-edge parameterizations satisfy 0 <= t <= 1
        if (_z_array[0] < -halfHeight)
        {
            if (_z_array[2] > halfHeight)
            {
                if (_z_array[1] >= halfHeight)
                {
                    // Cases 4a and 4b of Figure 1 in the PDF.
                    //
                    // The edge <V0,V1> is parameterized by V0+t*(V1-V0).
                    // On the bottom of the slab,
                    //   -h/2 = z0 + t * (z1 - z0)
                    //   t = (-h/2 - z0) / (z1 - z0) = numerNeg0 / denom10
                    // and on the tob of the slab,
                    //   +h/2 = z0 + t * (z1 - z0)
                    //   t = (+h/2 - z0) / (z1 - z0) = numerPos0 / denom10
                    //
                    // The edge <V0,V2> is parameterized by V0+t*(V2-V0).
                    // On the bottom of the slab,
                    //   -h/2 = z0 + t * (z2 - z0)
                    //   t = (-h/2 - z0) / (z2 - z0) = numerNeg0 / denom20
                    // and on the tob of the slab,
                    //   +h/2 = z0 + t * (z2 - z0)
                    //   t = (+h/2 - z0) / (z2 - z0) = numerPos0 / denom20
                    
                    var _numerNeg = -halfHeight - _z_array[0];
                    var _numerPos =  halfHeight - _z_array[0];
                    var _denom10  = _z_array[1] - _z_array[0];
                    var _denom20  = _z_array[2] - _z_array[0];
                    
                    var _dx10 = (_xy_array[1][0] - _xy_array[0][0]) / _denom10;
                    var _dy10 = (_xy_array[1][1] - _xy_array[0][1]) / _denom10;
                    var _dx20 = (_xy_array[2][0] - _xy_array[0][0]) / _denom20;
                    var _dy20 = (_xy_array[2][1] - _xy_array[0][1]) / _denom20;
                    
                    var _x = _xy_array[0][0];
                    var _y = _xy_array[0][1];
                    
                    var _polygon = [
                        [_x + _numerNeg*_dx20, _y + _numerNeg*_dy20],
                        [_x + _numerNeg*_dx10, _y + _numerNeg*_dy10],
                        [_x + _numerPos*_dx10, _y + _numerPos*_dy10],
                        [_x + _numerPos*_dx20, _y + _numerPos*_dy20],
                    ];
                    
                    var _intersects = __BonkDiskOverlapsPolygon(_polygon, radius);
                    return new BonkResult(_intersects);
                }
                else if (_z_array[1] <= -halfHeight)
                {
                    // Cases 4c and 4d of Figure 1 of the PDF.
                    //
                    // The edge <V2,V0> is parameterized by V0+t*(V2-V0).
                    // On the bottom of the slab,
                    //   -h/2 = z2 + t * (z0 - z2)
                    //   t = (-h/2 - z2) / (z0 - z2) = numerNeg2 / denom02
                    // and on the tob of the slab,
                    //   +h/2 = z2 + t * (z0 - z2)
                    //   t = (+h/2 - z2) / (z0 - z2) = numerPos2 / denom02
                    //
                    // The edge <V2,V1> is parameterized by V2+t*(V1-V2).
                    // On the bottom of the slab,
                    //   -h/2 = z2 + t * (z1 - z2)
                    //   t = (-h/2 - z2) / (z1 - z2) = numerNeg2 / denom12
                    // and on the top of the slab,
                    //   +h/2 = z2 + t * (z1 - z2)
                    //   t = (+h/2 - z2) / (z1 - z2) = numerPos2 / denom12
                    
                    var _numerNeg = -halfHeight - _z_array[2];
                    var _numerPos =  halfHeight - _z_array[2];
                    var _denom02  = _z_array[0] - _z_array[2];
                    var _denom12  = _z_array[1] - _z_array[2];
                    
                    var _dx02 = (_xy_array[0][0] - _xy_array[2][0]) / _denom02;
                    var _dy02 = (_xy_array[0][1] - _xy_array[2][1]) / _denom02;
                    var _dx12 = (_xy_array[1][0] - _xy_array[2][0]) / _denom12;
                    var _dy12 = (_xy_array[1][1] - _xy_array[2][1]) / _denom12;
                    
                    var _x = _xy_array[2][0];
                    var _y = _xy_array[2][1];
                    
                    var _polygon = [
                        [_x + _numerNeg*_dx02, _y + _numerNeg*_dy02],
                        [_x + _numerNeg*_dx12, _y + _numerNeg*_dy12],
                        [_x + _numerPos*_dx12, _y + _numerPos*_dy12],
                        [_x + _numerPos*_dx02, _y + _numerPos*_dy02],
                    ];
                    
                    var _intersects = __BonkDiskOverlapsPolygon(_polygon, radius);
                    return new BonkResult(_intersects);
                }
                else  // -halfHeight < z[1] < halfHeight
                {
                    // Case 5 of Figure 1 of the PDF.
                    //
                    // The edge <V0,V2> is parameterized by V0+t*(V2-V0).
                    // On the bottom of the slab,
                    //   -h/2 = z0 + t * (z2 - z0)
                    //   t = (-h/2 - z0) / (z2 - z0) = numerNeg0 / denom20
                    // and on the tob of the slab,
                    //   +h/2 = z0 + t * (z2 - z0)
                    //   t = (+h/2 - z0) / (z2 - z0) = numerPos0 / denom20
                    //
                    // The edge <V1,V0> is parameterized by V1+t*(V0-V1).
                    // On the bottom of the slab,
                    //   -h/2 = z1 + t * (z0 - z1)
                    //   t = (-h/2 - z1) / (z0 - z1) = numerNeg1 / denom01
                    //
                    // The edge <V1,V2> is parameterized by V1+t*(V2-V1).
                    // On the top of the slab,
                    //   +h/2 = z1 + t * (z2 - z1)
                    //   t = (+h/2 - z1) / (z2 - z1) = numerPos1 / denom21
                    
                    var _numerNeg0 = -halfHeight - _z_array[0];
                    var _numerPos0 =  halfHeight - _z_array[0];
                    var _numerNeg1 = -halfHeight - _z_array[1];
                    var _numerPos1 =  halfHeight - _z_array[1];
                    var _denom20   = _z_array[2] - _z_array[0];
                    var _denom01   = _z_array[0] - _z_array[1];
                    var _denom21   = _z_array[2] - _z_array[1];
                    
                    var _dx20 = (_xy_array[2][0] - _xy_array[0][0]) / _denom20;
                    var _dy20 = (_xy_array[2][1] - _xy_array[0][1]) / _denom20;
                    var _dx01 = (_xy_array[0][0] - _xy_array[1][0]) / _denom01;
                    var _dy01 = (_xy_array[0][1] - _xy_array[1][1]) / _denom01;
                    var _dx21 = (_xy_array[2][0] - _xy_array[1][0]) / _denom21;
                    var _dy21 = (_xy_array[2][1] - _xy_array[1][1]) / _denom21;
                    
                    var _x0 = _xy_array[0][0];
                    var _y0 = _xy_array[0][1];
                    var _x1 = _xy_array[0][0];
                    var _y1 = _xy_array[0][1];
                    
                    var _polygon = [
                        [_x0 + _numerNeg0*_dx20, _y0 + _numerNeg0*_dy20],
                        [_x1 + _numerNeg1*_dx01, _y1 + _numerNeg1*_dy01],
                        [_x1,                    _y1                   ],
                        [_x1 + _numerPos1*_dx21, _y1 + _numerPos1*_dy21],
                        [_x0 + _numerPos0*_dx20, _y0 + _numerPos0*_dy20],
                    ];
                    
                    var _intersects = __BonkDiskOverlapsPolygon(_polygon, radius);
                    return new BonkResult(_intersects);
                }
            }
            else if (_z_array[2] > -halfHeight)
            {
                if (_z_array[1] <= -halfHeight)
                {
                    // Cases 3b and 3c of Figure 1 of the PDF.
                    //
                    // The edge <V2,V0> is parameterized by V2+t*(V0-V2).
                    // On the bottom of the slab,
                    //   -h/2 = z2 + t * (z0 - z2)
                    //   t = (-h/2 - z2) / (z0 - z2) = numerNeg2 / denom02
                    //
                    // The edge <V2,V1> is parameterized by V2+t*(V1-V2).
                    // On the bottom of the slab,
                    //   -h/2 = z2 + t * (z1 - z2)
                    //   t = (-h/2 - z2) / (z1 - z2) = numerNeg2 / denom12
                    
                    var _numerNeg = -halfHeight - _z_array[2];
                    var _denom02  = _z_array[0] - _z_array[2];
                    var _denom12  = _z_array[1] - _z_array[2];
                    
                    var _dx02 = (_xy_array[0][0] - _xy_array[2][0]) / _denom02;
                    var _dy02 = (_xy_array[0][1] - _xy_array[2][1]) / _denom02;
                    var _dx12 = (_xy_array[1][0] - _xy_array[2][0]) / _denom12;
                    var _dy12 = (_xy_array[1][1] - _xy_array[2][1]) / _denom12;
                    
                    var _x = _xy_array[2][0];
                    var _y = _xy_array[2][1];
                    
                    var _polygon = [
                        [_x,                   _y                  ],
                        [_x + _numerNeg*_dx02, _y + _numerNeg*_dy02],
                        [_x + _numerNeg*_dx12, _y + _numerNeg*_dy12],
                    ];
                    
                    var _intersects = __BonkDiskOverlapsPolygon(_polygon, radius);
                    return new BonkResult(_intersects);
                }
                else // z[1] > -halfHeight
                {
                    // Case 4e of Figure 1 of the PDF.
                    //
                    // The edge <V0,V1> is parameterized by V0+t*(V1-V0).
                    // On the bottom of the slab,
                    //   -h/2 = z0 + t * (z1 - z0)
                    //   t = (-h/2 - z0) / (z1 - z0) = numerNeg0 / denom10
                    //
                    // The edge <V0,V2> is parameterized by V0+t*(V2-V0).
                    // On the bottom of the slab,
                    //   -h/2 = z0 + t * (z2 - z0)
                    //   t = (-h/2 - z0) / (z2 - z0) = numerNeg0 / denom20
                    var _numerNeg = -halfHeight - _z_array[0];
                    var _denom10  = _z_array[1] - _z_array[0];
                    var _denom20  = _z_array[2] - _z_array[0];
                    
                    var _dx20 = (_xy_array[2][0] - _xy_array[0][0]) / _denom20;
                    var _dy20 = (_xy_array[2][1] - _xy_array[0][1]) / _denom20;
                    var _dx10 = (_xy_array[1][0] - _xy_array[0][0]) / _denom10;
                    var _dy10 = (_xy_array[1][1] - _xy_array[0][1]) / _denom10;
                    
                    var _x = _xy_array[0][0];
                    var _y = _xy_array[0][1];
                    
                    var _polygon = [
                        [_x + _numerNeg*_dx20, _y + _numerNeg*_dy20],
                        [_x + _numerNeg*_dx10, _y + _numerNeg*_dy10],
                        [_xy_array[1][0], _xy_array[1][1]],
                        [_xy_array[2][0], _xy_array[2][1]],
                    ];
                    
                    var _intersects = __BonkDiskOverlapsPolygon(_polygon, radius);
                    return new BonkResult(_intersects);
                }
            }
            else  // z[2] == -hhalf
            {
                if (_z_array[1] < -halfHeight)
                {
                    // Case 1a of Figure 1 of the PDF.
                    var _intersects = __BonkDiskOverlapsPoint(_xy_array[2][0], _xy_array[2][1], radius);
                    return new BonkResult(_intersects);
                }
                else
                {
                    // Case 2a of Figure 1 of the PDF.
                    var _intersects = __BonkDiskOverlapsSegment(_xy_array[1][0], _xy_array[1][1], _xy_array[2][0], _xy_array[2][1], radius);
                    return new BonkResult(_intersects);
                }
            }
        }
        else if (_z_array[0] < halfHeight)
        {
            if (_z_array[1] >= halfHeight)
            {
                // Cases 3d and 3e of Figure 1 of the PDF.
                //
                // The edge <V0,V1> is parameterized by V0+t*(V1-V0).
                // On the top of the slab,
                //   +h/2 = z0 + t * (z1 - z0)
                //   t = (+h/2 - z0) / (z1 - z0) = numerPos0 / denom10
                //
                // The edge <V0,V2> is parameterized by V0+t*(V2-V0).
                // On the top of the slab,
                //   +h/2 = z0 + t * (z2 - z0)
                //   t = (+h/2 - z0) / (z2 - z0) = numerPos0 / denom20
                
                var _numerPos =  halfHeight - _z_array[0];
                var _denom10  = _z_array[1] - _z_array[0];
                var _denom20  = _z_array[2] - _z_array[0];
                
                var _dx10 = (_xy_array[1][0] - _xy_array[0][0]) / _denom10;
                var _dy10 = (_xy_array[1][1] - _xy_array[0][1]) / _denom10;
                var _dx20 = (_xy_array[2][0] - _xy_array[0][0]) / _denom20;
                var _dy20 = (_xy_array[2][1] - _xy_array[0][1]) / _denom20;
                
                var _x = _xy_array[0][0];
                var _y = _xy_array[0][1];
                
                var _polygon = [
                    [_x,                   _y                  ],
                    [_x + _numerPos*_dx10, _y + _numerPos*_dy10],
                    [_x + _numerPos*_dx20, _y + _numerPos*_dy20],
                ];
                
                var _intersects = __BonkDiskOverlapsPolygon(_polygon, radius);
                return new BonkResult(_intersects);
            }
            else // z[1] < hhalf
            {
                // Case 4f of Figure 1 of the PDF.
                //
                // The edge <V2,V0> is parameterized by V2+t*(V0-V2).
                // On the top of the slab,
                //   +h/2 = z2 + t * (z0 - z2)
                //   t = (+h/2 - z2) / (z0 - z2) = numerPos2 / denom02
                //
                // The edge <V2,V1> is parameterized by V2+t*(V1-V2).
                // On the top of the slab,
                //   +h/2 = z2 + t * (z1 - z2)
                //   t = (+h/2 - z2) / (z1 - z2) = numerPos2 / denom12
                
                var _numerPos =  halfHeight - _z_array[2];
                var _denom02  = _z_array[0] - _z_array[2];
                var _denom12  = _z_array[1] - _z_array[2];
                
                var _dx02 = (_xy_array[0][0] - _xy_array[2][0]) / _denom02;
                var _dy02 = (_xy_array[0][1] - _xy_array[2][1]) / _denom02;
                var _dx12 = (_xy_array[1][0] - _xy_array[2][0]) / _denom12;
                var _dy12 = (_xy_array[1][1] - _xy_array[2][1]) / _denom12;
                
                var _x = _xy_array[2][0];
                var _y = _xy_array[2][1];
                
                var _polygon = [
                    [_xy_array[0][0], _xy_array[0][1]],
                    [_xy_array[1][0], _xy_array[1][1]],
                    [_x + _numerPos*_dx12, _y + _numerPos*_dy12],
                    [_x + _numerPos*_dx02, _y + _numerPos*_dy02],
                ];
                
                var _intersects = __BonkDiskOverlapsPolygon(_polygon, radius);
                return new BonkResult(_intersects);
            }
        }
        else // z[0] == halfHeight
        {
            if (_z_array[1] > halfHeight)
            {
                // Case 1b of Figure 1 of the PDF.
                var _intersects = __BonkDiskOverlapsPoint(_xy_array[0][0], _xy_array[0][1], radius);
                return new BonkResult(_intersects);
            }
            else
            {
                // Case 2b of Figure 1 of the PDF.
                var _intersects = __BonkDiskOverlapsSegment(_xy_array[0][0], _xy_array[0][1], _xy_array[1][0], _xy_array[1][1], radius);
                return new BonkResult(_intersects);
            }
        }
    }
    
    #endregion
}
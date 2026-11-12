// Feather disable all

/// @param heightmap
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]

function BonkLineHitHeightmapNew(_heightmap, _lineX1, _lineY1, _lineZ1, _lineX2, _lineY2, _lineZ2, _struct = undefined)
{
    static _staticHit = new BonkResultHit();
    
    var _returnHit = _struct ?? _staticHit;
    
    with(_heightmap)
    {
        //Correct for the heightmap's position
        _lineX1 -= x;
        _lineY1 -= y;
        _lineZ1 -= z;
        
        _lineX2 -= x;
        _lineY2 -= y;
        _lineZ2 -= z;
        
        //TODO - Replace with incremental algo
        var _pointArray = __GetCellsFromLineExtInternal(_lineX1, _lineY1, _lineZ1,   _lineX2, _lineY2, _lineZ2);
        
        _lineX1 /= xScale;
        _lineY1 /= yScale;
        _lineZ1 /= zScale;
        
        _lineX2 /= xScale;
        _lineY2 /= yScale;
        _lineZ2 /= zScale;
        
        var _lineDX = _lineX2 - _lineX1;
        var _lineDY = _lineY2 - _lineY1;
        var _lineDZ = _lineZ2 - _lineZ1
        
        var _heightFunction = heightFunction;
        var _t1 = undefined;
        var _t2 = undefined;
        var _t  = undefined;
        
        var _i = 0;
        repeat(array_length(_pointArray) div 2)
        {
            var _cellX = _pointArray[_i  ];
            var _cellY = _pointArray[_i+1];
            
            var _cellZ1 = _heightFunction(_cellX,   _cellY  );
            var _cellZ2 = _heightFunction(_cellX+1, _cellY  );
            var _cellZ3 = _heightFunction(_cellX,   _cellY+1);
            var _cellZ4 = _heightFunction(_cellX+1, _cellY+1);
            
            var _dZ12 = _cellZ2 - _cellZ1;
            var _dZ13 = _cellZ3 - _cellZ1;
            var _dZ34 = _cellZ4 - _cellZ3;
            var _dZ12_dZ34 = _dZ34 - _dZ12;
            
            //var _v = 0;
            //repeat(6)
            //{
            //    var _u = 0;
            //    repeat(6)
            //    {
            //        var _x = x + xScale*(_cellX + _u);
            //        var _y = y + yScale*(_cellY + _v);
            //        var _z = z + zScale*(_cellZ1 + _u*_dZ12 + _v*_dZ13 + _u*_v*_dZ12_dZ34);
            //        UggSphere(_x, _y, _z, 2, c_lime, true);
            //        
            //        _u += 0.2;
            //    }
            //    
            //    _v += 0.2;
            //}
            //
            //var _u1 = undefined;
            //var _v1 = undefined;
            //var _w1 = undefined;
            //
            //var _u2 = x + xScale*_lineX1;
            //var _v2 = y + yScale*_lineY1;
            //var _w2 = z + zScale*(_cellZ1 + _lineX1*_dZ12 + _lineY1*_dZ13 + _lineX1*_lineY1*_dZ12_dZ34);
            //
            //var _t = 0;
            //repeat(21)
            //{
            //    _u1 = _u2;
            //    _v1 = _v2;
            //    _w1 = _w2;
            //    
            //    var _u = _lineX1 + _lineDX*_t;
            //    var _v = _lineY1 + _lineDY*_t;
            //    _w2 = z + zScale*(_cellZ1 + _u*_dZ12 + _v*_dZ13 + _u*_v*_dZ12_dZ34);
            //    _u2 = x + xScale*_u;
            //    _v2 = y + yScale*_v;
            //    
            //    UggLine(_u1, _v1, _w1,   _u2, _v2, _w2,   c_blue, undefined, true);
            //    
            //    _t += 0.05;
            //}
            
            //We'll find the point of intersection by intersection of the line segment with a curved surface for the cell
            //The cell's curved surface is defined by:
            //
            //  w = z1 + dz12.u + dz13.v + (dz34 - dz12).u.v
            //
            //Where u and v are from 0 to 1 (inclusive) and are the x/y coordinate within the cell. w is the z coordinate
            //within the cell. The equation of the line segment in the cell's coordinate space is:
            //
            //  u = x1 + dX.t
            //  v = y1 + dY.t
            //  w = z1 + dZ.t
            //
            //When we plug the equation of the line into the equation of the surface we get:
            //
            //  z1 + dZ.t = z1 + dz12(x1 + dX.t) + dz13(y1 + dY.t) + (dz34 - dz12)(x1 + dX.t)(y1 + dY.t)
            //
            //If we solve for t then we'll get the intersection point. Rearranging into a quadratic form yields:
            //
            //  0 = tt.a + t.b + a
            //  
            //  a = (dz34 - dz12).dX.dY
            //  b = dz12.dX + dz13 + (dz34 - dz12)(y1.dX + x1.dY) - dZ
            //  c = z1 + dz12.x1 + dz13.y1 + (dz34 - dz12).x1.y1 - z1
            //
            //We can then solve using the quadratic formula:
            //
            //  t = (-b +- sqrt(bb - 4ac)) / 2a
            
            var _lineU1 = _lineX1 - _cellX;
            var _lineV1 = _lineY1 - _cellY;
            
            //Quadratic solution:
            var _a = _dZ12_dZ34*_lineDX*_lineDY;
            var _b = _dZ12*_lineDX + _dZ13*_lineDY + _dZ12_dZ34*(_lineV1*_lineDX + _lineU1*_lineDY) - _lineDZ;
            var _c = _cellZ1 + _dZ12*_lineU1 + _dZ13*_lineV1 + _dZ12_dZ34*_lineU1*_lineV1 - _lineZ1;
            
            if (_a == 0)
            {
                _t1 = -_c / _b;
                _t2 = undefined;
            }
            else
            {
                var _det = _b*_b - 4*_a*_c;
                if (_det == 0)
                {
                    _t1 = -_b / (2*_a);
                    _t2 = undefined;
                }
                else if (_det > 0)
                {
                    var _t1 = (-_b - sqrt(_det)) / (2*_a);
                    var _t2 = (-_b + sqrt(_det)) / (2*_a);
                    
                    if ((_t1 >= 0) && (_t1 <= 1))
                    {
                        if ((_t2 >= 0) && (_t2 <= 1))
                        {
                            //Both intersection points are valid, try to solve using the first intersection point first
                            if (_t2 < _t1)
                            {
                                var _temp = _t1;
                                _t1 = _t2;
                                _t2 = _temp;
                            }
                        }
                        else
                        {
                            //Only t1 is valid
                            _t2 = undefined;
                        }
                    }
                    else
                    {
                        if ((_t2 >= 0) && (_t2 <= 1))
                        {
                            //Only t2 is valid
                            _t1 = undefined;
                        }
                        else
                        {
                            //Neither t1 nor t2 is valid
                            _t1 = undefined;
                            _t2 = undefined;
                        }
                    }
                }
                else
                {
                    //Line doesn't intersect curve
                    _t1 = undefined;
                    _t2 = undefined;
                }
            }
            
            if (_t1 != undefined)
            {
                var _u1 = _lineU1 + _t1*_lineDX;
                var _v1 = _lineV1 + _t1*_lineDY;
                
                if ((_u1 >= 0) && (_u1 <= 1) && (_v1 >= 0) && (_v1 <= 1))
                {
                    var _x = x + xScale*(_u1 + _cellX);
                    var _y = y + yScale*(_v1 + _cellY);
                    var _z = z + zScale*(_lineZ1 + _t1*_lineDZ);
                    UggSphere(_x, _y, _z, 3, c_yellow);
                    
                    _t = _t1;
                    break;
                }
            }
            
            if (_t2 != undefined)
            {
                var _u2 = _lineU1 + _t2*_lineDX;
                var _v2 = _lineV1 + _t2*_lineDY;
                        
                if ((_u2 >= 0) && (_u2 <= 1) && (_v2 >= 0) && (_v2 <= 1))
                {
                    var _x = x + xScale*(_u2 + _cellX);
                    var _y = y + yScale*(_v2 + _cellY);
                    var _z = z + zScale*(_lineZ1 + _t2*_lineDZ);
                    UggSphere(_x, _y, _z, 3, c_yellow);
                    
                    _t = _t2;
                    break;
                }
            }
            
            _i += 2;
        }
        
        if (_t != undefined)
        {
            var _x = x + xScale*(_lineX1 + _t*_lineDX);
            var _y = y + yScale*(_lineY1 + _t*_lineDY);
            var _z = z + zScale*(_lineZ1 + _t*_lineDZ);
            
            with(_returnHit)
            {
                shape = _heightmap;
                
                x = _x;
                y = _y;
                z = _z;
                
                normalX = 0;
                normalY = 0;
                normalZ = 1;
                
                return self;
            }
        }
    }
    return _returnHit.Null();
}
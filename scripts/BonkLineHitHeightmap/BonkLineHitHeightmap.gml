// Feather disable all

/// @param heightmap
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]

function BonkLineHitHeightmap(_heightmap, _lineX1, _lineY1, _lineZ1, _lineX2, _lineY2, _lineZ2, _struct = undefined)
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
        var _t1 = infinity;
        var _t2 = infinity;
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
            //  0 = tt.a + t.b + c
            //  
            //  a = (dz34 - dz12).dX.dY
            //  b = dz12.dX + dz13 + (dz34 - dz12)(y1.dX + x1.dY) - dZ
            //  c = z1 + dz12.x1 + dz13.y1 + (dz34 - dz12).x1.y1 - z1
            //
            //We can then solve using the quadratic formula:
            //
            //  t = (-b +- sqrt(bb - 4ac)) / 2a
            
            var _lineU = _lineX1 - _cellX;
            var _lineV = _lineY1 - _cellY;
            
            var _a = _dZ12_dZ34*_lineDX*_lineDY;
            var _b = _dZ12*_lineDX + _dZ13*_lineDY + _dZ12_dZ34*(_lineV*_lineDX + _lineU*_lineDY) - _lineDZ;
            var _c = _cellZ1 + _dZ12*_lineU + _dZ13*_lineV + _dZ12_dZ34*_lineU*_lineV - _lineZ1;
            
            if (_a == 0)
            {
                _t1 = -_c / _b;
                _t2 = infinity;
            }
            else
            {
                var _det = _b*_b - 4*_a*_c;
                if (_det == 0)
                {
                    //Line gracefully glances across the curve and gives us one solution
                    _t1 = -_b / (2*_a);
                    _t2 = infinity;
                }
                else if (_det > 0)
                {
                    var _t1 = (-_b - sqrt(_det)) / (2*_a);
                    var _t2 = (-_b + sqrt(_det)) / (2*_a);
                    
                    if (_t2 < _t1)
                    {
                        //Try to resolve in order of contact
                        var _temp = _t1;
                        _t1 = _t2;
                        _t2 = _temp;
                    }
                }
                else
                {
                    //Line doesn't intersect curve
                    _t1 = infinity;
                    _t2 = infinity;
                }
            }
            
            //Check if t1 gives us a valid point
            if ((_t1 >= 0) && (_t1 <= 1)) //On line
            {
                var _u = _lineU + _t1*_lineDX;
                var _v = _lineV + _t1*_lineDY;
                
                if ((_u >= 0) && (_u <= 1) && (_v >= 0) && (_v <= 1)) //Inside cell
                {
                    _t = _t1;
                    break;
                }
            }
            
            //Check if t2 gives us a valid point
            if ((_t2 >= 0) && (_t2 <= 1)) //On line
            {
                var _u = _lineU + _t2*_lineDX;
                var _v = _lineV + _t2*_lineDY;
                        
                if ((_u >= 0) && (_u <= 1) && (_v >= 0) && (_v <= 1)) //Inside cell
                {
                    _t = _t2;
                    break;
                }
            }
            
            _i += 2;
        }
        
        if (_t != undefined)
        {
            //Find the normal of the surface at the point of contact
            var _z1 = zScale*(_lineZ1 + _t*_lineDZ);
            var _z2 = zScale*(_cellZ1 + _dZ12*(_u + 0.001) + _dZ13*_v + _dZ12_dZ34*(_u + 0.001)*_v);
            var _z3 = zScale*(_cellZ1 + _dZ12*_u + _dZ13*(_v + 0.001) + _dZ12_dZ34*_u*(_v + 0.001));
            
            var _normalX = -0.001*yScale*(_z2 - _z1);
            var _normalY = -(_z3 - _z1)*0.001*xScale;
            var _normalZ = 0.001*xScale*0.001*yScale;
            
            //Then find the scaled up x/y coordinates
            var _x1 = xScale*(_u + _cellX);
            var _y1 = yScale*(_v + _cellY);
            
            with(_returnHit)
            {
                shape = _heightmap;
                
                //Recorrect for the heightmap's position
                x = other.x + _x1;
                y = other.y + _y1;
                z = other.z + _z1;
                
                //Normalize the normal
                var _length = point_distance_3d(0, 0, 0,   _normalX, _normalY, _normalZ)
                if (_length <= 0)
                {
                    normalX = 0;
                    normalY = 0;
                    normalZ = 0;
                }
                else
                {
                    normalX = _normalX / _length;
                    normalY = _normalY / _length;
                    normalZ = _normalZ / _length;
                }
                
                return self;
            }
        }
    }
    return _returnHit.Null();
}
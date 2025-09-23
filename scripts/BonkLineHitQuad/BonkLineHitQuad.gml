// Feather disable all

/// Returns the point of impact where a line meets a Bonk quad.
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The point of impact. If there is no collision, all three variables will be set to `0`.
/// 
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same struct
///      to be returned.
/// 
/// @param quad
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitQuad(_quad, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullHit = __Bonk().__nullHit;
    static _coordinate = new __BonkClassHit();
    
    with(_quad)
    {
        var _quadX1 = x1;
        var _quadY1 = y1;
        var _quadZ1 = z1;
        
        var _quadX2 = x2;
        var _quadY2 = y2;
        var _quadZ2 = z2;
        
        var _quadX4 = x3;
        var _quadY4 = y3;
        var _quadZ4 = z3;
        
        var _dX12 = _quadX2 - _quadX1;
        var _dY12 = _quadY2 - _quadY1;
        var _dZ12 = _quadZ2 - _quadZ1;
        
        var _dX41 = _quadX1 - _quadX4;
        var _dY41 = _quadY1 - _quadY4;
        var _dZ41 = _quadZ1 - _quadZ4;
        
        var _normalX = _dZ12*_dY41 - _dY12*_dZ41;
        var _normalY = _dX12*_dZ41 - _dZ12*_dX41;
        var _normalZ = _dY12*_dX41 - _dX12*_dY41;
        
        var _normalSqrLength = _normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ
        if (_normalSqrLength <= 0)
        {
            return _nullHit;
        }
        
        var _length = sqrt(_normalSqrLength);
        _normalX /= _length
        _normalY /= _length;
        _normalZ /= _length;
        
        var _quadX3 = _quadX2 - _dX41;
        var _quadY3 = _quadY2 - _dY41;
        var _quadZ3 = _quadZ2 - _dZ41;
        
        var _dX23 = -_dX41;
        var _dY23 = -_dY41;
        var _dZ23 = -_dZ41;
        
        var _dX34 = -_dX12;
        var _dY34 = -_dY12;
        var _dZ34 = -_dZ12;
        
        var _rX = _x2 - _x1;
        var _rY = _y2 - _y1;
        var _rZ = _z2 - _z1;
        
        var _dot = dot_product_3d(_rX, _rY, _rZ, _normalX, _normalY, _normalZ);
        if (_dot == 0)
        {
            //Ray lies on plane
            
            return _nullHit;
            
            //var _func = function(_x1, _y1, _z1,   _dX12, _dY12, _dZ12,   _x3, _y3, _z3,   _dX34, _dY34, _dZ34)
            //{
            //    var _dot13_21 = (_x1 - _x3)*_dX12 + (_y1 - _y3)*_dY12 + (_z1 - _z3)*_dZ12;
            //    var _dot13_43 = (_x1 - _x3)*_dX34 + (_y1 - _y3)*_dY34 + (_z1 - _z3)*_dZ34;
            //    var _dot21_21 = _dX12*_dX12 + _dY12*_dY12 + _dZ12*_dZ12;
            //    var _dot43_21 = _dX34*_dX12 + _dY34*_dY12 + _dZ34*_dZ12;
            //    var _dot43_43 = _dX34*_dX34 + _dY34*_dY34 + _dZ34*_dZ34;
            //    
            //    var _denominator = _dot21_21*_dot43_43 - _dot43_21*_dot43_21;
            //    if (_denominator == 0) return infinity;
            //    
            //    var _t = (_dot13_43*_dot43_21 - _dot13_21*_dot43_43) / _denominator;
            //    // t34 = (_dot13_43 + _t12*_dot43_21) / _dot43_43;
            //    
            //    return ((_t < 0) || (_t > 1))? infinity : _t;
            //}
            //
            //var _t = infinity;
            //_t = min(_t, _func(_x1, _y1, _z1,   _rX, _rY, _rZ,   _quadX1, _quadY1, _quadZ1,   _dX12, _dY12, _dZ12));
            //_t = min(_t, _func(_x1, _y1, _z1,   _rX, _rY, _rZ,   _quadX2, _quadY2, _quadZ2,   _dX23, _dY23, _dZ23));
            //_t = min(_t, _func(_x1, _y1, _z1,   _rX, _rY, _rZ,   _quadX3, _quadY3, _quadZ3,   _dX34, _dY34, _dZ34));
            //_t = min(_t, _func(_x1, _y1, _z1,   _rX, _rY, _rZ,   _quadX4, _quadY4, _quadZ4,   _dX41, _dY41, _dZ41));
            //
            //if (is_infinity(_t))
            //{
            //    //Something went wrong
            //    return _nullHit;
            //}
            //
            //with(_coordinate)
            //{
            //    x = _x1 + _t*_rX;
            //    y = _y1 + _t*_rY;
            //    z = _z1 + _t*_rZ;
            //}
            //
            //return _coordinate;
        }
        
        var _vX = _quadX1 - _x1;
        var _vY = _quadY1 - _y1;
        var _vZ = _quadZ1 - _z1;
        
        var _coeff = dot_product_3d(_vX, _vY, _vZ, _normalX, _normalY, _normalZ) / _dot;
        if ((_coeff < 0) || (_coeff > 1))
        {
            return _nullHit;
        }
        
        var _traceX = _x1 + _coeff*_rX;
        var _traceY = _y1 + _coeff*_rY;
        var _traceZ = _z1 + _coeff*_rZ;
        
        //Check the reference point is on the inner side of the edge 1->2
        var _vX = _traceX - _quadX1;
        var _vY = _traceY - _quadY1;
        var _vZ = _traceZ - _quadZ1;
        
        if (dot_product_3d(_vZ*_dY12 - _vY*_dZ12,
                           _vX*_dZ12 - _vZ*_dX12,
                           _vY*_dX12 - _vX*_dY12,
                           _normalX, _normalY, _normalZ) > 0)
        {
            //Check the reference point is on the inner side of the edge 2->3
            _vX = _traceX - _quadX2;
            _vY = _traceY - _quadY2;
            _vZ = _traceZ - _quadZ2;
            
            if (dot_product_3d(_vZ*_dY23 - _vY*_dZ23,
                               _vX*_dZ23 - _vZ*_dX23,
                               _vY*_dX23 - _vX*_dY23,
                               _normalX, _normalY, _normalZ) > 0)
            {
                //Check the reference point is on the inner side of the edge 3->4
                _vX = _traceX - _quadX3;
                _vY = _traceY - _quadY3;
                _vZ = _traceZ - _quadZ3;
                
                if (dot_product_3d(_vZ*_dY34 - _vY*_dZ34,
                                   _vX*_dZ34 - _vZ*_dX34,
                                   _vY*_dX34 - _vX*_dY34,
                                   _normalX, _normalY, _normalZ) > 0)
                {
                    //Check the reference point is on the inner side of the edge 4->1
                    _vX = _traceX - _quadX4;
                    _vY = _traceY - _quadY4;
                    _vZ = _traceZ - _quadZ4;
                    
                    if (dot_product_3d(_vZ*_dY41 - _vY*_dZ41,
                                       _vX*_dZ41 - _vZ*_dX41,
                                       _vY*_dX41 - _vX*_dY41,
                                       _normalX, _normalY, _normalZ) > 0)
                    {
                        with(_coordinate)
                        {
                            x = _traceX;
                            y = _traceY;
                            z = _traceZ;
                            
                            var _sign = -sign(_dot);
                            normalX = _sign*_normalX;
                            normalY = _sign*_normalY;
                            normalZ = _sign*_normalZ;
                        }
                        
                        return _coordinate;
                    }
                }
            }
        }
    }
    
    return _nullHit;
}
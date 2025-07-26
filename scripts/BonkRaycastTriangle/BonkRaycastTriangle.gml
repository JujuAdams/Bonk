// Feather disable all

/// @param triangle
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkRaycastTriangle(_triangle, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullCoordinate = __Bonk().__nullCoordiante;
    static _coordinate     = new __BonkClassCoordinate();
    
    with(_triangle)
    {
        var _triX1 = x1;
        var _triY1 = y1;
        var _triZ1 = z1;
        
        var _triX2 = x2;
        var _triY2 = y2;
        var _triZ2 = z2;
        
        var _triX3 = x3;
        var _triY3 = y3;
        var _triZ3 = z3;
        
        var _dX12 = _triX2 - _triX1;
        var _dY12 = _triY2 - _triY1;
        var _dZ12 = _triZ2 - _triZ1;
        
        var _dX31 = _triX1 - _triX3;
        var _dY31 = _triY1 - _triY3;
        var _dZ31 = _triZ1 - _triZ3;
        
        var _normalX = _dZ12*_dY31 - _dY12*_dZ31;
        var _normalY = _dX12*_dZ31 - _dZ12*_dX31;
        var _normalZ = _dY12*_dX31 - _dX12*_dY31;
        
        var _normalSqrLength = _normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ
        if (_normalSqrLength <= 0)
        {
            return _nullCoordinate;
        }
        
        var _length = sqrt(_normalSqrLength);
        _normalX /= _length
        _normalY /= _length;
        _normalZ /= _length;
        
        var _rX = _x2 - _x1;
        var _rY = _y2 - _y1;
        var _rZ = _z2 - _z1;
        
        var _dot = dot_product_3d(_rX, _rY, _rZ, _normalX, _normalY, _normalZ);
        if (_dot == 0)
        {
            //Ray lies on plane
            
            var _func = function(_x1, _y1, _z1,   _x2, _y2, _z2,   _x3, _y3, _z3,   _x4, _y4, _z4)
            {
                var _dot13_43 = (_x1 - _x3)*(_x4 - _x3) + (_y1 - _y3)*(_y4 - _y3) + (_z1 - _z3)*(_z4 - _z3);
                                                                    
                var _dot43_21 = (_x4 - _x3)*(_x2 - _x1) + (_y4 - _y3)*(_y2 - _y1) + (_z4 - _z3)*(_z2 - _z1);
                                                                    
                var _dot13_21 = (_x1 - _x3)*(_x2 - _x1) + (_y1 - _y3)*(_y2 - _y1) + (_z1 - _z3)*(_z2 - _z1);
                                                                    
                var _dot43_43 = (_x4 - _x3)*(_x4 - _x3) + (_y4 - _y3)*(_y4 - _y3) + (_z4 - _z3)*(_z4 - _z3);
                                                                    
                var _dot21_21 = (_x2 - _x1)*(_x2 - _x1) + (_y2 - _y1)*(_y2 - _y1) + (_z2 - _z1)*(_z2 - _z1);
                
                var _denominator = _dot21_21*_dot43_43 - _dot43_21*_dot43_21;
                if (_denominator == 0) return infinity;
                
                return (_dot13_43*_dot43_21 - _dot13_21*_dot43_43) / _denominator;
                // t34 = (_dot13_43 + _t12*_dot43_21) / _dot43_43;
            }
            
            var _t = infinity;
            _t = min(_t, _func(_x1, _y1, _z1,   _x2, _y2, _z2,   _triX1, _triY1, _triZ1,   _triX2, _triY2, _triZ2));
            _t = min(_t, _func(_x1, _y1, _z1,   _x2, _y2, _z2,   _triX2, _triY2, _triZ2,   _triX3, _triY3, _triZ3));
            _t = min(_t, _func(_x1, _y1, _z1,   _x2, _y2, _z2,   _triX3, _triY3, _triZ3,   _triX1, _triY1, _triZ1));
            
            if (is_infinity(_t))
            {
                //Something went wrong
                return _nullCoordinate;
            }
            
            with(_coordinate)
            {
                x = _x1 + _t*_rX;
                y = _y1 + _t*_rY;
                z = _z1 + _t*_rZ;
            }
            
            return _coordinate;
        }
        
        var _vX = _triX1 - _x1;
        var _vY = _triY1 - _y1;
        var _vZ = _triZ1 - _z1;
        
        var _coeff = dot_product_3d(_vX, _vY, _vZ, _normalX, _normalY, _normalZ) / _dot;
        var _traceX = _x1 + _coeff*_rX;
        var _traceY = _y1 + _coeff*_rY;
        var _traceZ = _z1 + _coeff*_rZ;
        
        var _vX = _traceX - _triX1;
        var _vY = _traceY - _triY1;
        var _vZ = _traceZ - _triZ1;
        
        if (dot_product_3d(_vZ*_dY12 - _vY*_dZ12,
                           _vX*_dZ12 - _vZ*_dX12,
                           _vY*_dX12 - _vX*_dY12,
                           _normalX, _normalY, _normalZ) > 0)
        {
            //Check the reference point is on the inner side of the edge 2->3
            //If we fail, these values fall through
            _vX = _traceX - _triX2;
            _vY = _traceY - _triY2;
            _vZ = _traceZ - _triZ2;
            
            var _dX23 = _triX3 - _triX2;
            var _dY23 = _triY3 - _triY2;
            var _dZ23 = _triZ3 - _triZ2;
            
            if (dot_product_3d(_vZ*_dY23 - _vY*_dZ23,
                               _vX*_dZ23 - _vZ*_dX23,
                               _vY*_dX23 - _vX*_dY23,
                               _normalX, _normalY, _normalZ) > 0)
            {
                //Check the reference point is on the inner side of the edge 3->1
                //If we fail, these values fall through
                _vX = _traceX - _triX3;
                _vY = _traceY - _triY3;
                _vZ = _traceZ - _triZ3;
                
                if (dot_product_3d(_vZ*_dY31 - _vY*_dZ31,
                                   _vX*_dZ31 - _vZ*_dX31,
                                   _vY*_dX31 - _vX*_dY31,
                                   _normalX, _normalY, _normalZ) > 0)
                {
                    with(_coordinate)
                    {
                        x = _traceX;
                        y = _traceY;
                        z = _traceZ;
                    }
                
                    return _coordinate;
                }
            }
        }
    }
    
    return _nullCoordinate;
}
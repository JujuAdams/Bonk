// Feather disable all

/// @param quad
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]

function BonkLineHitQuad(_quad, _x1, _y1, _z1, _x2, _y2, _z2, _struct = undefined)
{
    static _staticHit = new BonkResultHit();
    var _reaction = _struct ?? _staticHit;
    
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
            return _reaction.__Null();
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
            return _reaction.__Null();
        }
        
        var _vX = _quadX1 - _x1;
        var _vY = _quadY1 - _y1;
        var _vZ = _quadZ1 - _z1;
        
        var _coeff = dot_product_3d(_vX, _vY, _vZ, _normalX, _normalY, _normalZ) / _dot;
        if ((_coeff < 0) || (_coeff > 1))
        {
            return _reaction.__Null();
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
                        with(_reaction)
                        {
                            shape = _quad;
                            
                            x = _traceX;
                            y = _traceY;
                            z = _traceZ;
                            
                            var _sign = -sign(_dot);
                            normalX = _sign*_normalX;
                            normalY = _sign*_normalY;
                            normalZ = _sign*_normalZ;
                        }
                        
                        return _reaction;
                    }
                }
            }
        }
    }
    
    return _reaction.__Null();
}
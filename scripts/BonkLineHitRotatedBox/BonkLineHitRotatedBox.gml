// Feather disable all

/// @param box
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitRotatedBox(_box, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullHit    = __Bonk().__nullHit;
    static _coordinate = new __BonkClassHit();
    
    with(_box)
    {
        var _xMin = -0.5*xSize;
        var _xMax =  0.5*xSize;
        var _yMin = -0.5*ySize;
        var _yMax =  0.5*ySize;
        var _zMin = z - 0.5*zSize;
        var _zMax = z + 0.5*zSize;
        
        //Basis vectors
        var _cos = dcos(zRotation);
        var _sin = dsin(zRotation);
        
        var _iX =  _cos;
        var _iY = -_sin;
        
        var _jX = -_iY;
        var _jY =  _iX;
        
        var _dX1 = _x1 - x;
        var _dY1 = _y1 - y;
        var _dX2 = _x2 - x;
        var _dY2 = _y2 - y;
        
        var _i1 = _dX1*_iX + _dY1*_iY;
        var _j1 = _dX1*_jX + _dY1*_jY;
        
        var _i2 = _dX2*_iX + _dY2*_iY;
        var _j2 = _dX2*_jX + _dY2*_jY;
        
        var _dI = _i2 - _i1;
        var _dJ = _j2 - _j1;
        var _dZ = _z2 - _z1;
        
        if (_dI == 0)
        {
            var _t1 = -infinity;
            var _t2 =  infinity;
        }
        else
        {
            var _t1 = (_xMin - _i1) / _dI;
            var _t2 = (_xMax - _i1) / _dI;
        }
        
        if (_dJ == 0)
        {
            var _t3 = -infinity;
            var _t4 =  infinity;
        }
        else
        {
            var _t3 = (_yMin - _j1) / _dJ;
            var _t4 = (_yMax - _j1) / _dJ;
        }
        
        if (_dZ == 0)
        {
            var _t5 = -infinity;
            var _t6 =  infinity;
        }
        else
        {
            var _t5 = (_zMin - _z1) / _dZ;
            var _t6 = (_zMax - _z1) / _dZ;
        }
        
        var _tMin = max(min(_t1, _t2), min(_t3, _t4), min(_t5, _t6));
        var _tMax = min(max(_t1, _t2), max(_t3, _t4), max(_t5, _t6));
        
        if ((_tMax < 0) || (_tMax > 1) || (_tMin > _tMax))
        {
            return _nullHit;
        }
        
        var _t = (_tMin < 0)? _tMax : _tMin;
        var _pI = _i1 + _t*_dI;
        var _pJ = _j1 + _t*_dJ;
        var _pZ = _z1 + _t*_dZ;
        
        var _pX = x + _pI*_iX + _pJ*_jX;
        var _pY = y + _pI*_iY + _pJ*_jY;
        
        with(_coordinate)
        {
            x = _pX;
            y = _pY;
            z = _pZ;
        }
        
        return _coordinate;
    }
    
    return _nullHit;
}
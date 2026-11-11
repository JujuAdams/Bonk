// Feather disable all

/// @param x
/// @param y
/// @param z
/// @param heightmap
/// @param [struct]

function BonkPointCollideHeightmap(_pointX, _pointY, _pointZ, _heightmap, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    with(_heightmap)
    {
        var _cellX = (_pointX - x) / xScale;
        if ((_cellX < 0) || (_cellX > cellCountX))
        {
            return _reaction.Null();
        }
        
        var _cellY = (_pointY - y) / yScale;
        if ((_cellY < 0) || (_cellY > cellCountY))
        {
            return _reaction.Null();
        }
        
        var _funcLine = function(_cellX1, _cellY1, _cellZ1, _cellX2, _cellY2, _cellZ2)
        {
            //UggLine(x + xScale*_cellX1, y + yScale*_cellY1, z + zScale*_cellZ1,
            //        x + xScale*_cellX2, y + yScale*_cellY2, z + zScale*_cellZ2,
            //        undefined, 0.5);
        }
        
        var _zc = heightFunction(_cellX, _cellY);
        if (_pointZ >= z + zScale*_zc)
        {
            return _reaction.Null();
        }
        
        var _innerX = (_pointX - x) / xScale;
        var _innerY = (_pointY - y) / yScale;
        var _innerZ = (_pointZ - z) / zScale;
        
        _funcLine(_innerX, _innerY, _innerZ, _cellX, _cellY, _zc);
        
        var _intCellX = floor(_cellX);
        var _intCellY = floor(_cellY);
        
        var _x1 = _intCellX;
        var _y1 = _cellY;
        var _x2 = _intCellX + 1;
        var _y2 = _cellY;
        
        var _z1 = heightFunction(_x1, _y1);
        var _z2 = heightFunction(_x2, _y2);
        _funcLine(_x1, _y1, _z1, _x2, _y2, _z2);
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        var _coeff = 1 / point_distance_3d(0, 0, 0, _dX, _dY, _dZ);
        _dX *= _coeff;
        _dY *= _coeff;
        _dZ *= _coeff;
        
        var _vX = _innerX - _x1;
        var _vY = _innerY - _y1;
        var _vZ = _innerZ - _z1;
        var _dot = clamp(dot_product_3d(_vX, _vY, _vZ, _dX, _dY, _dZ), 0, 1);
        
        var _rX1 = _x1 + _dot*_dX;
        var _rY1 = _y1 + _dot*_dY;
        var _rZ1 = _z1 + _dot*_dZ;
        _funcLine(_innerX, _innerY, _innerZ, _rX1, _rY1, _rZ1);
        
        
        
        var _x1 = _cellX;
        var _y1 = _intCellY;
        var _x2 = _cellX;
        var _y2 = _intCellY + 1;
        
        var _z1 = heightFunction(_x1, _y1);
        var _z2 = heightFunction(_x2, _y2);
        _funcLine(_x1, _y1, _z1, _x2, _y2, _z2);
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        var _coeff = 1 / point_distance_3d(0, 0, 0, _dX, _dY, _dZ);
        _dX *= _coeff;
        _dY *= _coeff;
        _dZ *= _coeff;
        
        var _vX = _innerX - _x1;
        var _vY = _innerY - _y1;
        var _vZ = _innerZ - _z1;
        var _dot = clamp(dot_product_3d(_vX, _vY, _vZ, _dX, _dY, _dZ), 0, 1);
        
        var _rX2 = _x1 + _dot*_dX;
        var _rY2 = _y1 + _dot*_dY;
        var _rZ2 = _z1 + _dot*_dZ;
        _funcLine(_innerX, _innerY, _innerZ, _rX2, _rY2, _rZ2);
        
        _funcLine(_rX1, _rY1, _rZ1, _rX2, _rY2, _rZ2);
        
        var _x1 = _rX1;
        var _y1 = _rY1;
        var _z1 = _rZ1;
        var _x2 = _rX2;
        var _y2 = _rY2;
        var _z2 = _rZ2;
        _funcLine(_x1, _y1, _z1, _x2, _y2, _z2);
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        var _coeff = 1 / point_distance_3d(0, 0, 0, _dX, _dY, _dZ);
        _dX *= _coeff;
        _dY *= _coeff;
        _dZ *= _coeff;
        
        var _vX = _innerX - _x1;
        var _vY = _innerY - _y1;
        var _vZ = _innerZ - _z1;
        var _dot = clamp(dot_product_3d(_vX, _vY, _vZ, _dX, _dY, _dZ), 0, 1);
        
        var _rX3 = _x1 + _dot*_dX;
        var _rY3 = _y1 + _dot*_dY;
        var _rZ3 = _z1 + _dot*_dZ;
        _funcLine(_innerX, _innerY, _innerZ, _rX3, _rY3, _rZ3);
        
        _rX3 = x + xScale*_rX3;
        _rY3 = y + yScale*_rY3;
        _rZ3 = z + zScale*_rZ3;
        
        with(_reaction)
        {
            shape = _heightmap;
        
            dX = _rX3 - _pointX;
            dY = _rY3 - _pointY;
            dZ = _rZ3 - _pointZ;
        
            return self;
        }
    }
}
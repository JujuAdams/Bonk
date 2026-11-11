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
        
        var _zc = heightFunction(_cellX, _cellY);
        if (_pointZ >= z + zScale*_zc)
        {
            return _reaction.Null();
        }
        
        _cellX = floor(_cellX);
        _cellY = floor(_cellY);
        
        var _z1 = zScale*heightFunction(_cellX,   _cellY);
        var _z2 = zScale*heightFunction(_cellX+1, _cellY);
        var _z3 = zScale*heightFunction(_cellX,   _cellY+1);
        var _z4 = zScale*heightFunction(_cellX+1, _cellY+1);
        
        var _cellWorldX = x + xScale*_cellX;
        var _cellWorldY = y + yScale*_cellY;
        
        var _closestPoint = __BonkNearestPointOnCell(_pointX, _pointY, _pointZ,
                                                     _cellWorldX, _cellWorldY,
                                                     _cellWorldX + xScale, _cellWorldY + yScale,
                                                     _z1, _z2, _z3, _z4);
        
        with(_reaction)
        {
            shape = _heightmap;
        
            dX = _closestPoint.x - _pointX;
            dY = _closestPoint.y - _pointY;
            dZ = _closestPoint.z - _pointZ;
        
            return self;
        }
    }
}

function __BonkNearestPointOnCell(_pointX, _pointY, _pointZ,   _cellX1, _cellY1, _cellX2, _cellY2,   _cellZ1, _cellZ2, _cellZ3, _cellZ4)
{
    static _result = {};
    with(_result)
    {
        var _paramX = (_pointX - _cellX1) / (_cellX2 - _cellX1);
        var _paramY = (_pointY - _cellY1) / (_cellY2 - _cellY1);
        
        
        
        var _x1 = _cellX1;
        var _y1 = _pointY;
        var _z1 = lerp(_cellZ1, _cellZ3, _paramY);
        var _x2 = _cellX2;
        var _y2 = _pointY;
        var _z2 = lerp(_cellZ2, _cellZ4, _paramY);
        //UggLine(_x1, _y1, _z1,   _x2, _y2, _z2,   undefined, 0.5);
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        var _length = point_distance_3d(0, 0, 0,   _dX, _dY, _dZ);
        _dX /= _length;
        _dY /= _length;
        _dZ /= _length;
        
        var _vX = _pointX - _x1;
        var _vY = _pointY - _y1;
        var _vZ = _pointZ - _z1;
        var _dot = dot_product_3d(_vX, _vY, _vZ,   _dX, _dY, _dZ);
        _dot = clamp(_dot, 0, _length);
        
        var _rX1 = _x1 + _dot*_dX;
        var _rY1 = _y1 + _dot*_dY;
        var _rZ1 = _z1 + _dot*_dZ;
        //UggLine(_pointX, _pointY, _pointZ,   _rX1, _rY1, _rZ1,   undefined, 0.5);
        
        
        
        var _x1 = _pointX;
        var _y1 = _cellY1;
        var _z1 = lerp(_cellZ1, _cellZ2, _paramX);
        var _x2 = _pointX;
        var _y2 = _cellY2;
        var _z2 = lerp(_cellZ3, _cellZ4, _paramX);
        //UggLine(_x1, _y1, _z1,   _x2, _y2, _z2,   undefined, 0.5);
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        var _length = point_distance_3d(0, 0, 0,   _dX, _dY, _dZ);
        _dX /= _length;
        _dY /= _length;
        _dZ /= _length;
        
        var _vX = _pointX - _x1;
        var _vY = _pointY - _y1;
        var _vZ = _pointZ - _z1;
        var _dot = dot_product_3d(_vX, _vY, _vZ,   _dX, _dY, _dZ);
        _dot = clamp(_dot, 0, _length);
        
        var _rX2 = _x1 + _dot*_dX;
        var _rY2 = _y1 + _dot*_dY;
        var _rZ2 = _z1 + _dot*_dZ;
        //UggLine(_pointX, _pointY, _pointZ,   _rX2, _rY2, _rZ2,   undefined, 0.5);
        
        
        
        var _x1 = _rX1;
        var _y1 = _rY1;
        var _z1 = _rZ1;
        var _x2 = _rX2;
        var _y2 = _rY2;
        var _z2 = _rZ2;
        //UggLine(_x1, _y1, _z1,   _x2, _y2, _z2,   undefined, 0.5);
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        var _length = point_distance_3d(0, 0, 0,   _dX, _dY, _dZ);
        _dX /= _length;
        _dY /= _length;
        _dZ /= _length;
        
        var _vX = _pointX - _x1;
        var _vY = _pointY - _y1;
        var _vZ = _pointZ - _z1;
        var _dot = dot_product_3d(_vX, _vY, _vZ,   _dX, _dY, _dZ);
        _dot = clamp(_dot, 0, _length);
        
        x = _x1 + _dot*_dX;
        y = _y1 + _dot*_dY;
        z = _z1 + _dot*_dZ;
        //UggLine(_pointX, _pointY, _pointZ,   x, y, z,   undefined, 0.5);
        
        
        
        return self;
    }
}
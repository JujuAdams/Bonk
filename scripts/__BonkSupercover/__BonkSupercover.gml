// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [array]

function __BonkSupercover(_x1, _y1, _z1, _x2, _y2, _z2, _array = [])
{
    var _xDelta = _x2 - _x1;
    var _yDelta = _y2 - _y1;
    var _zDelta = _z2 - _z1;
    
    var _xDeltaAbs = max(math_get_epsilon(), abs(_xDelta));
    var _yDeltaAbs = max(math_get_epsilon(), abs(_yDelta));
    var _zDeltaAbs = max(math_get_epsilon(), abs(_zDelta));
    
    var _xSign = sign(_xDelta);
    var _ySign = sign(_yDelta);
    var _zSign = sign(_zDelta);
    
    var _x2Grid = floor(_x2);
    var _y2Grid = floor(_y2);
    var _z2Grid = floor(_z2);
    
    //We always have the origin cell
    var _xWrite = floor(_x1);
    var _yWrite = floor(_y1);
    var _zWrite = floor(_z1);
    
    array_push(_array,   _xWrite, _yWrite, _zWrite);
    
    var _xWalk = frac(abs(_x1));
    var _yWalk = frac(abs(_y1));
    var _zWalk = frac(abs(_z1));
    
    if (_xDelta < 0)
    {
        _xWalk = 1 - _xWalk;
    }
    
    if (_yDelta < 0)
    {
        _yWalk = 1 - _yWalk;
    }
    
    if (_zDelta < 0)
    {
        _zWalk = 1 - _zWalk;
    }
    
    while((_xWrite != _x2Grid) || (_yWrite != _y2Grid) || (_zWrite != _z2Grid))
    {
        var _tX = (1 - _xWalk) / _xDeltaAbs;
        var _tY = (1 - _yWalk) / _yDeltaAbs;
        var _tZ = (1 - _zWalk) / _zDeltaAbs;
        
        if (_tX < _tY)
        {
            if (_tX < _tZ)
            {
                _xWalk  = 0;
                _yWalk += _tX*_yDeltaAbs;
                _zWalk += _tX*_zDeltaAbs;
                
                _xWrite += _xSign;
            }
            else if (_tZ < _tX)
            {
                _xWalk += _tZ*_xDeltaAbs;
                _yWalk += _tZ*_yDeltaAbs;
                _zWalk  = 0;
                
                _zWrite += _zSign;
            }
            else //if (_tX == _tZ)
            {
                //Line travels diagonally in the xz plane
                
                array_push(_array,   _xWrite + _xSign, _yWrite, _zWrite         );
                array_push(_array,   _xWrite,          _yWrite, _zWrite + _zSign);
                
                _xWalk  = 0;
                _yWalk += _tX*_yDeltaAbs;
                _zWalk  = 0;
                
                _xWrite += _xSign;
                _zWrite += _zSign;
            }
        }
        else if (_tY < _tX)
        {
            if (_tY < _tZ)
            {
                _xWalk += _tY*_xDeltaAbs;
                _yWalk  = 0;
                _zWalk += _tY*_zDeltaAbs;
                
                _yWrite += _ySign;
            }
            else if (_tZ < _tY)
            {
                _xWalk += _tZ*_xDeltaAbs;
                _yWalk += _tZ*_yDeltaAbs;
                _zWalk  = 0;
                
                _zWrite += _zSign;
            }
            else //if (_tY == _tZ)
            {
                //Line travels diagonally in the yz plane
                
                array_push(_array,   _xWrite, _yWrite + _ySign, _zWrite         );
                array_push(_array,   _xWrite, _yWrite,          _zWrite + _zSign);
                
                _xWalk += _tY*_xDeltaAbs;
                _yWalk  = 0;
                _zWalk  = 0;
                
                _yWrite += _ySign;
                _zWrite += _zSign;
            }
        }
        else //if (_tX == _tY)
        {
            if (_tX < _tZ)
            {
                //Line travels diagonally in the xy plane
                
                array_push(_array,   _xWrite + _xSign, _yWrite,          _zWrite);
                array_push(_array,   _xWrite,          _yWrite + _ySign, _zWrite);
                
                _xWalk  = 0;
                _yWalk  = 0;
                _zWalk += _tY*_zDeltaAbs;
                
                _xWrite += _xSign;
                _yWrite += _ySign;
            }
            else if (_tZ < _tX)
            {
                _xWalk += _tZ*_xDeltaAbs;
                _yWalk += _tZ*_yDeltaAbs;
                _zWalk  = 0;
                
                _zWrite += _zSign;
            }
            else //if (_tX == _tZ)
            {
                //Three way tie!
                
                array_push(_array,   _xWrite + _xSign, _yWrite,          _zWrite         );
                array_push(_array,   _xWrite,          _yWrite + _ySign, _zWrite         );
                array_push(_array,   _xWrite,          _yWrite,          _zWrite + _zSign);
                
                array_push(_array,   _xWrite + _xSign, _yWrite + _ySign, _zWrite);
                array_push(_array,   _xWrite,          _yWrite + _ySign, _zWrite + _zSign);
                array_push(_array,   _xWrite + _xSign, _yWrite,          _zWrite + _zSign);
                
                _xWalk = 0;
                _yWalk = 0;
                _zWalk = 0;
                
                _xWrite += _xSign;
                _yWrite += _ySign;
                _zWrite += _zSign;
            }
        }
        
        array_push(_array,   _xWrite, _yWrite, _zWrite);
    }
    
    return _array;
}
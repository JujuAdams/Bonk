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
    
    //Find which direction the line is headed in. We're OK with `sign()` returning 0 here
    var _xSign = sign(_xDelta);
    var _ySign = sign(_yDelta);
    var _zSign = sign(_zDelta);
    
    //Don't allow divide-by-zero anywhere
    if (_xDelta == 0) _xDelta = math_get_epsilon();
    if (_yDelta == 0) _yDelta = math_get_epsilon();
    if (_zDelta == 0) _zDelta = math_get_epsilon();
    
    //Find the length of the line in each axis. We use this to determine where the line segment
    //crosses each cell boundary (effectively using the gradient)
    var _xIncrAbs = 1 / abs(_xDelta);
    var _yIncrAbs = 1 / abs(_yDelta);
    var _zIncrAbs = 1 / abs(_zDelta);
    
    //Track which cell we've most recently visited
    var _xWrite = floor(_x1);
    var _yWrite = floor(_y1);
    var _zWrite = floor(_z1);
    
    //We always visit the origin cell so let's push that now
    array_push(_array,   _xWrite, _yWrite, _zWrite);
    
    //Figure out the t value ("parameter of the line") for each axis. We use `abs()` to handle edge
    //cases. The t-parameter values should always be positive initially!
    var _tX = (_xSign > 0)? (1 - frac(_x1)) : frac(_x1);
    var _tY = (_ySign > 0)? (1 - frac(_y1)) : frac(_y1);
    var _tZ = (_zSign > 0)? (1 - frac(_z1)) : frac(_z1);
    
    _tX *= _xIncrAbs;
    _tY *= _yIncrAbs;
    _tZ *= _zIncrAbs;
    
    if (BONK_SUPERCOVER_DEBUG)
    {
        var _i = 0;
    }
    
    //Find the smallest t value as this gives us the closest cell face where the line crosses
    //into the next cell. Depending on which face/axis is closest, we choose to move into a
    //different cell
    while(min(_tX, _tY, _tZ) < 1)
    {
        if (BONK_SUPERCOVER_DEBUG)
        {
            ++_i;
            if (_i >= 1000)
            {
                if (BONK_RUNNING_FROM_IDE)
                {
                    __BonkTrace($"Found very long loop for supercover input parameters:  ({_x1}, {_y1}, {_z1}) -> ({_x2}, {_y2}, {_z2})");
                    show_message($"Bonk:\nFound very long loop for supercover input parameters:\n({_x1}, {_y1}, {_z1}) -> ({_x2}, {_y2}, {_z2})\nA copy of this information can be found in the debug log.\n\nPlease report this error.");
                }
                
                break;
            }
        }
        
        if (_tX < _tY)
        {
            if (_tX < _tZ)
            {
                _xWrite += _xSign;
                _tX += _xIncrAbs;
            }
            else if (_tZ < _tX)
            {
                _zWrite += _zSign;
                _tZ += _zIncrAbs;
            }
            else //if (_tX == _tZ)
            {
                //Line travels diagonally in the xz plane
                
                array_push(_array,   _xWrite + _xSign, _yWrite, _zWrite         );
                array_push(_array,   _xWrite,          _yWrite, _zWrite + _zSign);
                
                _xWrite += _xSign;
                _zWrite += _zSign;
                
                _tX += _xIncrAbs;
                _tZ += _zIncrAbs;
            }
        }
        else if (_tY < _tX)
        {
            if (_tY < _tZ)
            {
                _yWrite += _ySign;
                _tY += _yIncrAbs;
            }
            else if (_tZ < _tY)
            {
                _zWrite += _zSign;
                _tZ += _zIncrAbs;
            }
            else //if (_tY == _tZ)
            {
                //Line travels diagonally in the yz plane
                
                array_push(_array,   _xWrite, _yWrite + _ySign, _zWrite         );
                array_push(_array,   _xWrite, _yWrite,          _zWrite + _zSign);
                
                _yWrite += _ySign;
                _zWrite += _zSign;
                
                _tY += _yIncrAbs;
                _tZ += _zIncrAbs;
            }
        }
        else //if (_tX == _tY)
        {
            if (_tX < _tZ)
            {
                //Line travels diagonally in the xy plane
                
                array_push(_array,   _xWrite + _xSign, _yWrite,          _zWrite);
                array_push(_array,   _xWrite,          _yWrite + _ySign, _zWrite);
                
                _xWrite += _xSign;
                _yWrite += _ySign;
                
                _tX += _xIncrAbs;
                _tY += _yIncrAbs;
            }
            else if (_tZ < _tX)
            {
                _zWrite += _zSign;
                _tZ += _zIncrAbs;
            }
            else //if (_tX == _tZ)
            {
                //Three way tie!
                
                array_push(_array,   _xWrite + _xSign, _yWrite,          _zWrite         );
                array_push(_array,   _xWrite,          _yWrite + _ySign, _zWrite         );
                array_push(_array,   _xWrite,          _yWrite,          _zWrite + _zSign);
                
                array_push(_array,   _xWrite + _xSign, _yWrite + _ySign, _zWrite         );
                array_push(_array,   _xWrite,          _yWrite + _ySign, _zWrite + _zSign);
                array_push(_array,   _xWrite + _xSign, _yWrite,          _zWrite + _zSign);
                
                _xWrite += _xSign;
                _yWrite += _ySign;
                _zWrite += _zSign;
                
                _tX += _xIncrAbs;
                _tY += _yIncrAbs;
                _tZ += _zIncrAbs;
            }
        }
        
        array_push(_array,   _xWrite, _yWrite, _zWrite);
    }
    
    return _array;
}
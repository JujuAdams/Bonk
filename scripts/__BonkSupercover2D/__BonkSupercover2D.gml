// Feather disable all

/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param [array]

function __BonkSupercover2D(_x1, _y1, _x2, _y2, _array = [])
{
    var _xDelta = _x2 - _x1;
    var _yDelta = _y2 - _y1;
    
    //Find which direction the line is headed in. We're OK with `sign()` returning 0 here
    var _xSign = sign(_xDelta);
    var _ySign = sign(_yDelta);
    
    //Don't allow divide-by-zero anywhere
    if (_xDelta == 0) _xDelta = math_get_epsilon();
    if (_yDelta == 0) _yDelta = math_get_epsilon();
    
    //Find the length of the line in each axis. We use this to determine where the line segment
    //crosses each cell boundary (effectively using the gradient)
    var _xIncrAbs = 1 / abs(_xDelta);
    var _yIncrAbs = 1 / abs(_yDelta);
    
    //Track which cell we've most recently visited
    var _xWrite = floor(_x1);
    var _yWrite = floor(_y1);
    
    //We always visit the origin cell so let's push that now
    array_push(_array,   _xWrite, _yWrite);
    
    //Find the relative coordinates for the next intersection located on the face of the cube we're
    //inside
    var _nextX = ((_xSign < 0)? _xWrite : (_xWrite+1)) - _x1;
    var _nextY = ((_ySign < 0)? _yWrite : (_yWrite+1)) - _y1;
    
    //Convert the coordinates into line parameter values
    var _tX = _nextX / _xDelta;
    var _tY = _nextY / _yDelta;
    
    if (BONK_SUPERCOVER_DEBUG)
    {
        var _i = 0;
    }
    
    //Find the smallest t value as this gives us the closest cell face where the line crosses
    //into the next cell. Depending on which face/axis is closest, we choose to move into a
    //different cell
    while(min(_tX, _tY) < 1)
    {
        if (BONK_SUPERCOVER_DEBUG)
        {
            ++_i;
            if (_i >= 1000)
            {
                if (BONK_RUNNING_FROM_IDE)
                {
                    __BonkTrace($"Found very long loop for supercover input parameters:  ({_x1}, {_y1}) -> ({_x2}, {_y2})");
                    show_message($"Bonk:\nFound very long loop for supercover input parameters:\n({_x1}, {_y1}) -> ({_x2}, {_y2})\nA copy of this information can be found in the debug log.\n\nPlease report this error.");
                }
                
                break;
            }
        }
        
        if (_tX < _tY)
        {
            array_push(_array,   _xWrite + _xSign, _yWrite, 0);
            array_push(_array,   _xWrite,          _yWrite, 0);
            
            _xWrite += _xSign;
            
            _tX += _xIncrAbs;
        }
        else if (_tY < _tX)
        {
            array_push(_array,   _xWrite, _yWrite + _ySign, 0);
            array_push(_array,   _xWrite, _yWrite,          0);
            
            _yWrite += _ySign;
            
            _tY += _yIncrAbs;
        }
        else //if (_tX == _tY)
        {
            //Line travels diagonally in the xy plane
            
            array_push(_array,   _xWrite + _xSign, _yWrite,          0);
            array_push(_array,   _xWrite,          _yWrite + _ySign, 0);
            
            _xWrite += _xSign;
            _yWrite += _ySign;
            
            _tX += _xIncrAbs;
            _tY += _yIncrAbs;
        }
        
        array_push(_array,   _xWrite, _yWrite, 0);
    }
    
    return _array;
}
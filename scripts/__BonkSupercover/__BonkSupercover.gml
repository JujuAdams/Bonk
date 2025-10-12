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
    
    //Find the length of the line in each axis. We use this to determine where the line segment
    //crosses each cell boundary (effectively using the gradient)
    var _xDeltaAbs = abs(_xDelta);
    var _yDeltaAbs = abs(_yDelta);
    var _zDeltaAbs = abs(_zDelta);
    
    //Find which direction the line is headed in. We're OK with `sign()` returning 0 here
    var _xSign = sign(_xDelta);
    var _ySign = sign(_yDelta);
    var _zSign = sign(_zDelta);
    
    //Track which cell we've most recently visited
    var _xVisit = floor(_x1);
    var _yVisit = floor(_y1);
    var _zVisit = floor(_z1);
    
    //We always visit the origin cell so let's push that now
    array_push(_array,   _xVisit, _yVisit, _zVisit);
    
    if ((floor(_x2) == _xVisit) && (floor(_y2) == _yVisit) && (floor(_z2) == _zVisit))
    {
        //If the line segment starts and ends in the same cell then early out
        return _array;
    }
    
    //Track where we are within the current cell using normalized coordinates
    var _xWalk = frac(abs(_x1));
    var _yWalk = frac(abs(_y1));
    var _zWalk = frac(abs(_z1));
    
    //If we're going backwards in any axis then mirror the starting position of the line segment
    if ((_xDelta < 0) && (_xWalk > 0))
    {
        _xWalk = 1 - _xWalk;
    }
    
    if ((_yDelta < 0) && (_yWalk > 0))
    {
        _yWalk = 1 - _yWalk;
    }
    
    if ((_zDelta < 0) && (_zWalk > 0))
    {
        _zWalk = 1 - _zWalk;
    }
    
    //Track how far we've moved along the line in absolute coordinates
    var _xCount = 0;
    var _yCount = 0;
    var _zCount = 0;
    
    if (BONK_SUPERCOVER_DEBUG)
    {
        var _i = 0;
    }
    
    while((_xCount < _xDeltaAbs) || (_yCount < _yDeltaAbs) || (_zCount < _zDeltaAbs))
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
        
        //Figure out the t value ("parameter of the line") for each axis
        var _tX = (1 - _xWalk) / _xDeltaAbs;
        var _tY = (1 - _yWalk) / _yDeltaAbs;
        var _tZ = (1 - _zWalk) / _zDeltaAbs;
        
        //Find the smallest t value as this gives us the closest cell face where the line crosses
        //into the next cell. Depending on which face/axis is closest, we choose to move into a
        //different cell
        
        if (_tX < _tY)
        {
            if (_tX < _tZ)
            {
                _xWalk  = 0;
                _yWalk += _tX*_yDeltaAbs;
                _zWalk += _tX*_zDeltaAbs;
                
                _xVisit += _xSign;
                
                _xCount++;
            }
            else if (_tZ < _tX)
            {
                _xWalk += _tZ*_xDeltaAbs;
                _yWalk += _tZ*_yDeltaAbs;
                _zWalk  = 0;
                
                _zVisit += _zSign;
                
                _zCount++;
            }
            else //if (_tX == _tZ)
            {
                //Line travels diagonally in the xz plane
                
                array_push(_array,   _xVisit + _xSign, _yVisit, _zVisit         );
                array_push(_array,   _xVisit,          _yVisit, _zVisit + _zSign);
                
                _xWalk  = 0;
                _yWalk += _tX*_yDeltaAbs;
                _zWalk  = 0;
                
                _xVisit += _xSign;
                _zVisit += _zSign;
                
                _xCount++;
                _zCount++;
            }
        }
        else if (_tY < _tX)
        {
            if (_tY < _tZ)
            {
                _xWalk += _tY*_xDeltaAbs;
                _yWalk  = 0;
                _zWalk += _tY*_zDeltaAbs;
                
                _yVisit += _ySign;
                
                _yCount++;
            }
            else if (_tZ < _tY)
            {
                _xWalk += _tZ*_xDeltaAbs;
                _yWalk += _tZ*_yDeltaAbs;
                _zWalk  = 0;
                
                _zVisit += _zSign;
                
                _zCount++;
            }
            else //if (_tY == _tZ)
            {
                //Line travels diagonally in the yz plane
                
                array_push(_array,   _xVisit, _yVisit + _ySign, _zVisit         );
                array_push(_array,   _xVisit, _yVisit,          _zVisit + _zSign);
                
                _xWalk += _tY*_xDeltaAbs;
                _yWalk  = 0;
                _zWalk  = 0;
                
                _yVisit += _ySign;
                _zVisit += _zSign;
                
                _yCount++;
                _zCount++;
            }
        }
        else //if (_tX == _tY)
        {
            if (_tX < _tZ)
            {
                //Line travels diagonally in the xy plane
                
                array_push(_array,   _xVisit + _xSign, _yVisit,          _zVisit);
                array_push(_array,   _xVisit,          _yVisit + _ySign, _zVisit);
                
                _xWalk  = 0;
                _yWalk  = 0;
                _zWalk += _tY*_zDeltaAbs;
                
                _xVisit += _xSign;
                _yVisit += _ySign;
                
                _xCount++;
                _yCount++;
            }
            else if (_tZ < _tX)
            {
                _xWalk += _tZ*_xDeltaAbs;
                _yWalk += _tZ*_yDeltaAbs;
                _zWalk  = 0;
                
                _zVisit += _zSign;
                
                _zCount++;
            }
            else //if (_tX == _tZ)
            {
                //Three way tie!
                
                array_push(_array,   _xVisit + _xSign, _yVisit,          _zVisit         );
                array_push(_array,   _xVisit,          _yVisit + _ySign, _zVisit         );
                array_push(_array,   _xVisit,          _yVisit,          _zVisit + _zSign);
                
                array_push(_array,   _xVisit + _xSign, _yVisit + _ySign, _zVisit         );
                array_push(_array,   _xVisit,          _yVisit + _ySign, _zVisit + _zSign);
                array_push(_array,   _xVisit + _xSign, _yVisit,          _zVisit + _zSign);
                
                _xWalk = 0;
                _yWalk = 0;
                _zWalk = 0;
                
                _xVisit += _xSign;
                _yVisit += _ySign;
                _zVisit += _zSign;
                
                _xCount++;
                _yCount++;
                _zCount++;
            }
        }
        
        array_push(_array,   _xVisit, _yVisit, _zVisit);
    }
    
    return _array;
}
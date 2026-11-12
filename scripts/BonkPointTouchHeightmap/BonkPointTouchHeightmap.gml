// Feather disable all

/// @param heightmap
/// @param x
/// @param y
/// @param z

function BonkPointTouchHeightmap(_heightmap, _pointX, _pointY, _pointZ)
{
    var _z = _heightmap.GetZ(_pointX, _pointY);
    if (_z == undefined)
    {
        return false;
    }
    
    return (_pointZ <= _z);
}
// Feather disable all

/// @param x
/// @param y
/// @param z
/// @param heightmap

function BonkPointTouchHeightmap(_pointX, _pointY, _pointZ, _heightmap)
{
    var _z = _heightmap.GetZ(_pointX, _pointY);
    if (_z == undefined)
    {
        return false;
    }
    
    return (_pointZ <= _z);
}
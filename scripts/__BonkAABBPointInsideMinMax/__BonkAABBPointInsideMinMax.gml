// Feather disable all

/// @param point
/// @param aabbMin
/// @param aabbMax

function __BonkAABBPointInsideMinMax(_point, _min, _max)
{
    if (_point[0] < _min[0]) return false;
    if (_point[1] < _min[1]) return false;
    if (_point[2] < _min[2]) return false;
    if (_point[0] > _max[0]) return false;
    if (_point[1] > _max[1]) return false;
    if (_point[2] > _max[2]) return false;
    
    return true;
}
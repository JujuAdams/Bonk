// Feather disable all

/// @param point1
/// @param point2

function BonkPointInPoint(_point1, _point2)
{
    with(_point1)
    {
        return ((x == _point2.x) && (y == _point2.y) && (z == _point2.z));
    }
    
    return false;
}
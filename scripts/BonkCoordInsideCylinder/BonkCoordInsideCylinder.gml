// Feather disable all

/// Returns whether a coordinate lies inside a cylinder.
/// 
/// @param x
/// @param y
/// @param z
/// @param cylinder

function BonkCoordInsideCylinder(_x, _y, _z, _cylinder)
{
    with(_cylinder)
    {
        if ((_z < z - 0.5*height) || (_z > z + 0.5*height)) return false;
        return (point_distance(_x, _y, x, y) < radius);
    }
    
    return false;
}
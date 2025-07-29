// Feather disable all

/// Returns whether a Bonk pole and sphere overlap.
///
/// @param pole
/// @param sphere

function BonkPoleInsideSphere(_pole, _sphere)
{
    with(_pole)
    {
        var _poleZMin = z - 0.5*height;
        var _poleZMax = z + 0.5*height;
    }
    
    with(_sphere)
    {
        return (point_distance_3d(_pole.x, _pole.y, clamp(z, _poleZMin, _poleZMax),   x, y, z) < radius);
    }
}
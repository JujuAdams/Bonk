// Feather disable all

/// Returns whether a Bonk pole and cylinder overlap.
///
/// @param pole
/// @param cylinder

function BonkPoleInsideCylinder(_pole, _cylinder)
{
    with(_pole)
    {
        var _capsuleX    = x;
        var _capsuleY    = y;
        var _capsuleZMin = z - 0.5*height;
        var _capsuleZMax = z + 0.5*height;
    }
    
    with(_cylinder)
    {
        return ((point_distance(x, y, _capsuleX, _capsuleY) < radius)
            &&  (_capsuleZMin < z + 0.5*height) && (_capsuleZMax > z - 0.5*height))
    }
}
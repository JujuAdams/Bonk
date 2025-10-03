// Feather disable all

/// Returns whether a Bonk capsule and cylinder overlap.
///
/// @param capsule
/// @param cylinder

function BonkCapsuleTouchCylinder(_capsule, _cylinder)
{
    with(_capsule)
    {
        var _capsuleRadius = radius;
        var _capsuleX      = x;
        var _capsuleY      = y;
        var _capsuleZ      = z;
        var _capsuleZMin   = _capsuleZ - 0.5*height + radius;
        var _capsuleZMax   = _capsuleZ + 0.5*height - radius;
    }
    
    with(_cylinder)
    {
        var _dX = _capsuleX - x;
        var _dY = _capsuleY - y;
        
        var _dist = sqrt(_dX*_dX + _dY*_dY);
        if (_dist <= 0)
        {
            var _cylinderX = _capsuleX;
            var _cylinderY = _capsuleY;
        }
        else
        {
            var _coeff = min(1, radius/_dist);
            var _cylinderX = x + _coeff*_dX;
            var _cylinderY = y + _coeff*_dY;
        }
        
        var _cylinderZ = clamp(_capsuleZ, z - 0.5*height, z + 0.5*height);
    }
    
    return (point_distance_3d(_cylinderX, _cylinderY, _cylinderZ, _capsuleX, _capsuleY, clamp(_cylinderZ, _capsuleZMin, _capsuleZMax)) < _capsuleRadius);
}
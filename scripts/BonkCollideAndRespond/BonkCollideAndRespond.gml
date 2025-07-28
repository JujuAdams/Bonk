// Feather disable all

/// @param subjectShape
/// @param otherShape
/// @param [angleThreshold=36]

function BonkCollideAndRespond(_subjectShape, _otherShape, _angleThreshold = 36)
{
    with(_subjectShape)
    {
        var _reaction = Collide(_otherShape);
        if (_reaction.collision)
        {
            var _dX = _reaction.dX;
            var _dY = _reaction.dY;
            var _dZ = _reaction.dZ;
            
            var _distance = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
            if ((_dZ / _distance) > clamp(dcos(_angleThreshold), 0, 1))
            {
                //If the slope is shallow enough, just move upwards
                //This movement is approximate but good enough
                z += _distance;
            }
            else
            {
                //Otherwise move out as per normal which will typically slide the subject down slopes
                x += _dX;
                y += _dY;
                z += _dZ;
            }
        }
    }
}
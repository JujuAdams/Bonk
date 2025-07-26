// Feather disable all

/// @param subjectShape
/// @param otherShape
/// @param speedContainer

function BonkCollideAndRespond(_subjectShape, _otherShape, _speedContainer)
{
    with(_subjectShape)
    {
        var _reaction = Collide(_otherShape);
        if (_reaction.collision)
        {
            var _dX = _reaction.dX;
            var _dY = _reaction.dY;
            var _dZ = _reaction.dZ;
            
            x += _dX;
            y += _dY;
            z += _dZ;
            
            var _normalSqrLength = _dX*_dX + _dY*_dY + _dZ*_dZ
            if (_normalSqrLength > 0)
            {
                with(_speedContainer)
                {
                    var _coeff = dot_product_3d(xSpeed, ySpeed, zSpeed, _dX, _dY, _dZ) / _normalSqrLength;
                    xSpeed -= _coeff*_dX;
                    ySpeed -= _coeff*_dY;
                    zSpeed -= _coeff*_dZ;
                }
            }
        }
    }
}
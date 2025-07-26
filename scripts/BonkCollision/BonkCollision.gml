// Feather disable all

/// @param speedContainer
/// @param shape
/// @param otherShape

function BonkCollision(_speedContainer, _shape, _otherShape)
{
    var _reaction = _shape.Collide(_otherShape);
    if (_reaction.collision)
    {
        with(_shape)
        {
            x += _reaction.dX;
            y += _reaction.dY;
            z += _reaction.dZ;
        }
        
        with(_speedContainer)
        {
            //TODO - Inline
            var _velocityProjection = BonkVecProjectOntoPlane(xSpeed, ySpeed, zSpeed, _reaction.dX, _reaction.dY, _reaction.dZ);
            xSpeed = _velocityProjection.x;
            ySpeed = _velocityProjection.y;
            zSpeed = _velocityProjection.z;
        }
    }
}